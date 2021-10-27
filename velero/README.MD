# Backup e Restauração do k8s com Velero

## Motivação e Filosofia

Se faz necessário termos mecanismos de backup em diversos níveis para seguir planos de continuidade de negócios e de recuperação de desastres.

Com o Velero é possível criar backups de Clusteres Kubernetes inteiros, inclusive de PVCs e seus dados, além de aplicações (Versões de Releases do Helm inclusive) e [CRDs](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/).

## Instalação do Velero Client
Instale o cliente do Velero em sua máquina para ter acesso a ferramenta de linha de comando

```
brew update \
brew install velero
```

Para mais opções de instalação acesse a [documentação](https://velero.io/docs/v1.6/basic-install/#install-the-cli)

## Instalação do Velero Server no Cluster k8s

Modifique as permissões dos scripts, habilitando execução:

```
chmod +x ./velero/*.sh
```

Caso necessite instalar o server do Velero no Cluster execute o script:

```
./velero/install.sh <NOME_DO_BUCKET> <CAMINHO_SERVICE_ACCOUNT>
```

Nota:

- Optou-se por utilizar a GCP como provider de armazenamento.

Consulte os [Cloud Providers suportados](https://velero.io/docs/v1.6/supported-providers/) para mais opções de armazenamento remoto.

- A service account da GCP deve ter no mínimo o privilégio de `Storage Admin`

### Validação da instalação

Após a instalação do server do Velero aguarde alguns segundos e:

- Verifique se o backup-location tem o valor `Available` para o atributo `PHASE`:

```
velero get backup-locations
```

- Verifique se o pod do Velero está rodando

```
kubectl get pods -n velero
```

## Cluster Backup

Backups automáticos são feitos:

- Diariamente às 03AM (UTC -3) no cluster de produção

- Semanalmente às sextas-feiras às 03AM (UTC -3) no cluster de homologação


Caso deseje criar um backup manualmente execute o script:

```
./velero/backup.sh <NOME_DO_BACKUP>
```

Um arquivo `tarball` será salvo direto no bucket do serviço de storage (GCS)

### Validando o Backup

É possível validar o backup criado. Este deve apresentar o valor `Completed` em verde no atributo `Phase`

```
velero backup describe <NOME_BACKUP>
```

Para exibir mais detalhes do backup utilize o argumento `--details`

```
velero backup describe <NOME_BACKUP> --details
```

## Recuperando um Backup em um novo Cluster

Antes de iniciar o processo de recuperação de cluster certifique-se dos requisitos:

- Novo Cluster tem uma service account associada com privilégios: `Storage Admin`, `Kubernetes Engine Admin` e `Compute Admin`

- Desinstale os Recursos do Istio no cluster antigo com o comando abaixo e certifique-se de que o IP relativo ao host (Ex: IP do apis.volanty.com, IP do quantovaleomeucarro.com.br) não esteja [associado a um recurso do antigo cluster k8s](https://console.cloud.google.com/networking/addresses/list)

```
./velero/istio-purge.sh
```

Execute o script para iniciar a recuperação do cluster:

```
./velero/restore.sh <NOME_DO_BACKUP>
```

## Validação da Restauração

A restauração completa é um processo que pode demorar alguns minutos.

Avalie os seguintes critérios após a restauração ser concluida:

- Cluster tem um IP Externo associado ao Istio Ingressgateway! Execute o comando e avalie a saída:

```
kubectl get svc istio-ingressgateway -n istio-system
```

Se o status do `External IP` estiver marcado como `<Pending>`, o LoadBalancer não conseguiu alocar o IP. Certifique-se que o IP não esteja associado a nenhum recurso antigo!

- Recuperação das versões das releases dos Charts Helm.

```
helm ls
```

- Deployment do Elasticsearch responde com os dados do PVC

```
kubectl port-forward statefulset/elasticsearch-elasticsearch -n elasticsearch 9200:9200
```

```
curl -v http://localhost:9200/catalog/_search
```

## Atualizando Ambientes

### Configurando contexto para o novo cluster

```
gcloud container clusters get-credentials <NOME_NOVO_CLUSTER> \
--zone <ZONA> \
--project <NOME_PROJETO>
```

### Configurando CI/CD

Altere as variáveis de ambiente no Bitbucket:

- Cluster em Homologação: `STAGING_CLUSTER`

- Cluster em Produção: `PRODUCTION_CLUSTER`
