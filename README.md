# projet-Terraform

## Les prérequis

- Créer une instance Ubuntu 22.04
- Installer Terraform sur Ubuntu en utilisant la commande suivante : `apt install terraform` 
- Ouvrir Visual Studio Code et installer le plugin "HarshiCorp Terraform"

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

## Création d'un utilisateur IAM et une clé d'accès

### Un utilisateur IAM
1- Choisir le service IAM et cliquer sur créer un utilisateur
![1](/uploads/b6c57451b858d68091f5a6d479e1ae32/1.PNG)

2-Spécifier les détails de l'utilisateur 
![2](/uploads/032f128dfae4a0423c77ec3533afa275/2.PNG)

3-Choisir `l'option Attacher directementdes politiques` et choisir `AdministratorAcces` comme politique d'autorisation
![3](/uploads/c87f9692cc6254d1692eba57c40668bd/3.PNG)

4- Vérifier et cliquer sur `Créer un utilisateur`
![4](/uploads/50e99415d86c6b748ae1662b7e27c158/4.PNG)

### Clé d'accès

1- Cliquer l'utilisateur crée et choisir l'onglet `Informations d'identification de sécurité`
![5](/uploads/b61bb064eb63446beda2fba0dead4f95/5.PNG)

2- Cliquer sur créer une clé d'accès 
![6](/uploads/fb72b47652b26a278a0d39edfeb123a5/6.PNG)

3- Choisir `Interface de ligne de commande (CLI)` 
![7](/uploads/79f101d0ce16ea8eaae089fbbcc75c40/7.PNG)

4- Définir une identification de la description 
![8](/uploads/1e174c4337d800545bd6ec97971fa04c/8.PNG)
 
 5- Télécharger le fichier .csv
![9](/uploads/7ca9015ae56f0ed821ae43e92db4ac83/9.PNG)

Revenir au terminal et taper la commande `aws configure` et taper la clé d'accès et la clé d'accès secrète

Générer une paire de clés SSH (clé publique et clé privée) en utilisant la commande: 

`ssh-keygen -t rsa -f ~/.ssh/ma_cle`  -t pour spécifier le type de clé (par défaut RSA), et l'option -f pour indiquer le nom du fichier où la clé sera enregistrée.


## Lancement de Terraform

 Initialisation

 `terraform init`

 Prévisualiser les actions que Terraform va effectuer

 `terraform plan`

  Appliquer les modifications spécifiées dans les fichiers de configuration Terraform sur notre infrastructure

 `terraform apply`
