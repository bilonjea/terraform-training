# Terraform Training

Projet Terraform pour préparer l'environnement d'une session de
formation Terraform.

Le projet est organisé autour de modules afin de séparer :

-   la création et la gestion des comptes IAM étudiants ;
-   la création optionnelle d'un workstation AWS de secours.

## Architecture

``` text
terraform-training/
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── versions.tf
│
└── modules/
    ├── iam/
    │   ├── iam-users.tf
    │   ├── ...
    │   └── README.md
    │
    └── workstation/
        ├── variables.tf
        ├── locals.tf
        ├── data.tf
        ├── network.tf
        ├── security-group.tf
        ├── ec2.tf
        ├── ...
        ├── README.md
        └── templates/
            └── userdata.sh.tftpl


                  ROOT
                   │
        ┌──────────┼──────────┐
        ▼          ▼          ▼
       IAM       Secrets   Workstation
        │          │          ▲
        │          │          │
        └──────────►──────────┘


                    IAM
                     │
          AccessKey + SecretKey
                     │
                     ▼
             Workstation
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
   student01    student02    student03
        │            │            │
        ▼            ▼            ▼
   ~/.aws/       ~/.aws/       ~/.aws/
 credentials    credentials    credentials
        │            │            │
        ▼            ▼            ▼
 AWS_PROFILE    AWS_PROFILE    AWS_PROFILE
 = student01    = student02    = student03

```

## Modules

### IAM

Le module `iam` crée les comptes AWS utilisés par les étudiants et leurs
credentials.

Il expose notamment :

``` text
student_aws_credentials
```

Ces credentials sont directement transmis au module `workstation`.

Aucun fichier JSON intermédiaire n'est nécessaire.

### Workstation

Le module `workstation` crée un poste de secours AWS pour les sessions
où les ordinateurs des étudiants ne sont pas disponibles ou correctement
configurés.

Le workstation peut être activé ou désactivé depuis le projet racine.

## Paramètres principaux

### Région de déploiement

``` hcl
aws_region = "us-east-1"
```

Cette variable correspond à la région dans laquelle l'infrastructure de
formation est déployée.

### Nombre d'étudiants

``` hcl
student_count = 10
```

Le nombre d'étudiants est utilisé par le module IAM et le module
workstation.

### Régions AWS autorisées

``` hcl
allowed_aws_regions = [
  "eu-west-3",
  "eu-west-1",
  "eu-central-1",
  "us-east-1"
]
```

Ces régions correspondent aux régions que les étudiants sont autorisés à
utiliser pour leurs exercices.

### Workstation de secours

``` hcl
create_workstation = true
```

Mettre `true` pour créer le workstation.

Mettre `false` lorsque les ordinateurs des étudiants sont déjà
configurés et que le workstation de secours n'est pas nécessaire.

## Déploiement

Initialiser Terraform :

``` bash
terraform init
```

Vérifier la configuration :

``` bash
terraform validate
```

Afficher le plan :

``` bash
terraform plan
```

Appliquer :

``` bash
terraform apply
```

Détruire l'environnement :

``` bash
terraform destroy
```

## Outputs

Le projet racine peut exposer les informations utiles provenant des
modules, notamment l'adresse IP publique du workstation et son mot de
passe étudiant lorsqu'il est créé.

Exemples :

``` bash
terraform output workstation_public_ip
```

Pour une valeur sensible :

``` bash
terraform output -raw student_password
```

## Principe des modules

Les modules reçoivent leurs paramètres via des variables :

``` text
Root
  │
  ├── variables
  ▼
Module
```

Ils exposent les informations nécessaires au reste du projet via des
outputs :

``` text
Module
  │
  └── output
       ▼
      Root
```

Le root peut ensuite transmettre l'output d'un module à un autre :

``` text
IAM
 │
 └── student_aws_credentials
          │
          ▼
        Root
          │
          ▼
     Workstation
```

## Cycle de vie

L'infrastructure est conçue pour être temporaire et peut être
entièrement supprimée avec :

``` bash
terraform destroy
```

Le workstation est optionnel afin de pouvoir utiliser le même projet
pour différentes sessions de formation.

