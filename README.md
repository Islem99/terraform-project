# terraform-project

## Les prérequis

- Créer une instance Ubuntu 22.04
- Installer Terraform sur Ubuntu en utilisant la commande suivante : `apt install terraform` 
- Ouvrir Visual Studio et installer le plugin "HarshiCorp Terraform"

## Les objectifs de projet Terraform

Terraform est un outil open-source d'infrastructure en tant que code (IaC), il permet de provisionner et de gérer des ressources sur différents fournisseurs de cloud et environnements sur site.
Dans nore cas nous allons provisionner les ressources une instance AWS en utilisant Terraform.

Une fois que les prérequis sont installés, nous entamons l'écriture du code, ce code a pour objectif:

 1) Créer un VPC (Virtual Private Cloud)
 2) Créer un sous-réseau (Custom Subnet)
 3) Créer une table de routage (route table) et une passerelle internet (internet gateway)
 4) Provisionner une instance EC2
 5) Créer un groupe de sécurité (Security Group) en tant que pare-feu pour l'instance EC2.
 6) ce projet nécessite un espace de stockage assez important donc vous devez ajouter un espace de disque.
 

 Nous pouvons également définir nos variables directement dans les fichiers Terraform (*.tf) mais le plus recommandé pour générer des variables Terraform, nous devons les définir dans un fichier de configuration avec l'extension .tfvars (par exemple, variables.tfvars) pour définir nos variables. Nous pouvons utiliser ce fichier pour stocker toutes vos variables spécifiques à un  environnement ou à un scénario particulier.


## Lancement de Terraform

 Initialisation

 `terraform init`

 Prévisualiser les actions que Terraform va effectuer

 `terraform plan`

  Appliquer les modifications spécifiées dans les fichiers de configuration Terraform sur notre infrastructure

 `terraform apply`
