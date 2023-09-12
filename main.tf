# Configuration du fournisseur AWS et de la région où les ressources seront créées
provider "aws" {
  region = var.region  # Définit la région AWS où les ressources seront créées
}

# Création d'une Virtual Private Cloud (VPC) pour isoler le réseau
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block  # Plage d'adresses IP pour la VPC
  tags = {
    Name = "${var.env_prefix}-vpc"  # Étiquette pour identifier la VPC
  }
}

# Création d'un sous-réseau dans la VPC pour la segmentation
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.myapp-vpc.id  # ID de la VPC parente
  cidr_block        = var.subnet_1_cidr_block  # Plage d'adresses IP pour le sous-réseau
  availability_zone = var.avail_zone  # Zone de disponibilité pour le sous-réseau
  tags = {
    Name = "${var.env_prefix}-subnet-1"  # Étiquette pour identifier le sous-réseau
  }
}

# Création d'une passerelle Internet pour permettre l'accès depuis Internet
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id  # Attache la passerelle à la VPC
  tags = {
    Name = "${var.env_prefix}-internet-gateway"  # Étiquette pour identifier la passerelle Internet
  }
}

# Création d'une table de routage par défaut pour diriger le trafic sortant
resource "aws_default_route_table" "main_rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id  # ID de la table de routage par défaut de la VPC

  # Définition d'une règle de routage par défaut vers la passerelle Internet
  route {
    cidr_block = "0.0.0.0/0"  # Tout le trafic sortant
    gateway_id = aws_internet_gateway.myapp-igw.id  # Utilise la passerelle Internet comme prochaine étape
  }

  tags = {
    Name = "${var.env_prefix}-main_rtb"  # Étiquette pour identifier la table de routage
  }
}

# Création d'un groupe de sécurité par défaut pour contrôler le trafic réseau
resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.myapp-vpc.id  # Associe le groupe de sécurité à la VPC

  # Règles d'entrée (trafic entrant)
  ingress {
    from_port   = 22  # Port SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]  # Autorise uniquement l'adresse IP spécifiée pour SSH
  }

  # Règles d'entrée pour le port 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Règles d'entrée pour le port 5601 (Kibana)
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Règles d'entrée pour le port 9092 (Kafka)
  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Règles d'entrée pour le port 5432 (Postgres)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Règles d'entrée pour le port 9200
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Règles d'entrée pour le port 9600 (Récupération des données)
  ingress {
    from_port   = 9600
    to_port     = 9600
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Règles de sortie (trafic sortant)
  egress {
    from_port       = 0  # Tous les ports source
    to_port         = 0  # Tous les ports destination
    protocol        = "-1"  # Tous les protocoles
    cidr_blocks     = ["0.0.0.0/0"]  # Autorise tout le trafic sortant
    prefix_list_ids = []  # Pas de restrictions supplémentaires
  }

  tags = {
    Name = "${var.env_prefix}-default-sg"  # Étiquette pour identifier le groupe de sécurité
  }
}

# Création d'une instance EC2 (serveur virtuel)
resource "aws_instance" "myapp-server" {
  ami           = "ami-05b5a865c3579bbc4"  # ID de l'image Amazon Machine Image (AMI)
  instance_type = var.instance_type  # Type d'instance (taille et performances)
  key_name      = aws_key_pair.ssh-key.key_name  # Nom de la paire de clés SSH
  associate_public_ip_address = true  # Associe une adresse IP publique
  subnet_id     = aws_subnet.myapp-subnet-1.id  # Attache l'instance au sous-réseau spécifié
  vpc_security_group_ids      = [aws_default_security_group.default-sg.id]  # Associe le groupe de sécurité par défaut
  availability_zone = var.avail_zone  # Zone de disponibilité pour le déploiement

  # Configuration du disque racine de l'instance
  root_block_device {
    volume_size = 50  # Taille du volume en gigaoctets
    volume_type = "gp2"  # Type de stockage (General Purpose SSD)
  }

  tags = {
    Name = "${var.env_prefix}-server"  # Étiquette pour identifier l'instance
  }
}

# Création d'une paire de clés SSH pour l'accès sécurisé
resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"  # Nom de la clé SSH
  public_key = "${file(var.public_key_location)}"  # Emplacement de la clé publique sur le disque
}

resource "aws_eip" "elasticip" {
  instance = aws_instance.myapp-server.id

}

output "EIP"{
  value = aws_eip.elasticip.public_ip
}
