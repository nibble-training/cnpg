# cnpg cli

This is just a summary of commands, which you can run and check the output:

```
kubectl cnpg report --help

kubectl cnpg status example-1

kubectl cnpg report cluster example-1
unzip report_cluster_example-1_*.zip

kubectl cnpg report operator
unzip report_operator_*.zip

kubectl cnpg hibernate on example-1
kubectl get pod
kubectl cnpg hibernate off example-1
kubectl get pod

kubectl cnpg pgadmin4 example-1
```
