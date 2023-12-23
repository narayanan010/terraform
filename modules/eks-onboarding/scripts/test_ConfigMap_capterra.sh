# Script for testing EKS user access to ConfigMap
#!/bin/bash
resources="pods deployments"

if [ ${environment} != "prod" ] && [ ${environment} != "staging" ] && [ ${environment} != "sandbox" ]
then
    echo "Please set ENV variable 'environment' with [ prod / staging / sandbox]"
    exit 1
else
    case ${environment} in
        production)
            #aws_profile="eks-production-cluster-general-admin"
            eks_context="arn:aws:eks:${aws_region}:176540105868:cluster/${eks_name}"
            ;;
        production-dr)
            #aws_profile="eks-production-cluster-general-admin"
            eks_context="arn:aws:eks:${aws_region}:176540105868:cluster/${eks_name}"
            ;;
        staging)
            #aws_profile="eks-staging-cluster-general-admin"
            eks_context="arn:aws:eks:${aws_region}:176540105868:cluster/${eks_name}"
            ;;
        sandbox)
            aws_profile="capterra-sandbox-admin"
            eks_context="arn:aws:eks:${aws_region}:944864126557:cluster/${eks_name}"
            ;;
    esac
fi

if [ -z ${namespace} ]
then
    echo "Please set ENV variable 'namespace' with the new value namespace of EKS cluster"
    exit 1
fi

if [ -z ${eks_name} ]
then
    echo "Please set ENV variable 'eks_name' with ID of EKS cluster"
    exit 1
fi

if [ -z ${aws_region} ]
then
    echo "Please set ENV variable 'aws_region' with value where EKS cluster is located"
    exit 1
fi

user="${namespace}-${environment}-deployer-user"
#user="${namespace}-${environment}-ro-user"

# Alias for aws-vault. Expand aliases
# Remplaced by Pipeline execution!
echo "=== Alias for aws-vault (account: ${aws_profile})"
shopt -s expand_aliases
alias aws="aws-vault exec ${aws_profile} -- aws"
alias kubectl="aws-vault exec ${aws_profile} -- kubectl"

# Set cluster context
aws eks update-kubeconfig --name ${eks_name} --region ${aws_region}
if [ $? -ne 0 ]
then
    echo "=== ERROR: aws eks update-kubeconfig --name ${eks_name} --region ${aws_region}"
    exit 1
fi
kubectl config use-context ${eks_context}

echo ""
echo "Run ConfigMap validation"
echo "------------------------------"
echo "=== NAMESPACE: ${namespace} ==="
echo "=== USER: ${user} ==="
for verb in create delete get list patch update watch; do
    echo "-- ${verb} --"
    for resource in ${resources}; do
        printf "Resource ${resource}: "
        kubectl auth can-i ${verb} ${resource} -n ${namespace} --as=${user}
    done
done