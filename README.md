# Terraform Training Workstation — Vault POC

POC d'une plateforme Terraform permettant de créer une workstation de formation AWS avec plusieurs comptes étudiants et une gestion des credentials via HashiCorp Vault.

> ⚠️ Projet destiné à une formation. Pas conçu pour la production.

## Architecture

```text
PC Formateur
     │
     │ IP publique Vault
     ▼
┌─────────────────────────────────────────────┐
│                    AWS                      │
│                                             │
│  Workstation EC2 ──── IP privée ────► Vault │
│       │                                  EC2 │
│       │ IAM Role                         │  │
│       ▼                                  │  │
│ workstation-role                    KV v2   │
│                                      training
└─────────────────────────────────────────────┘
```

## Organisation Terraform

Le projet utilise deux states Terraform indépendants.

### `infrastructure/`

Gère l'infrastructure AWS :

- réseau / VPC
- Security Groups
- IAM
- Workstation EC2
- Vault EC2
- Elastic IP
- Secrets Manager
- configuration de la workstation

### `vault-config/`

Gère la configuration interne de Vault :

- AWS Auth
- rôle Vault `workstation`
- policy `workstation-training`
- mount KV v2 `training`
- secrets des étudiants

Cette séparation évite que le `destroy` de l'infrastructure AWS ait besoin de contacter Vault.

## Gestion des credentials

Le projet supporte :

```hcl
credentials_mode = "local"
```

```hcl
credentials_mode = "secrets_manager"
```

```hcl
credentials_mode = "vault"
```

Le POC Vault utilise :

```hcl
credentials_mode = "vault"
```

Les credentials sont stockés dans :

```text
training/
└── students/
    ├── student01
    ├── student02
    ├── ...
    └── student10
```

Chaque secret contient notamment :

- username AWS
- console password
- access key
- secret key

## Authentification Vault

La workstation utilise son rôle IAM AWS pour s'authentifier auprès de Vault :

```text
Workstation IAM Role
        │
        ▼
Vault AWS Auth
        │
        ▼
role = workstation
        │
        ▼
policy = workstation-training
        │
        ▼
training/students/*
```

La workstation utilise l'IP privée du serveur Vault.

Le root Terraform `vault-config`, exécuté depuis le PC du formateur, utilise l'IP publique du serveur Vault.

## Mount KV

Le nom du mount est configurable depuis le root `vault-config` :

```hcl
vault_mount = "training"
```

Cette valeur est utilisée par :

```text
vault_mount
    │
    ├──► mount KV
    ├──► Vault policy
    └──► vault-secrets
```

## Dépendance entre modules

Les secrets étudiants dépendent de la création préalable du mount KV :

```hcl
depends_on = [
  module.vault_config
]
```

Ordre :

```text
vault-config
     │
     ├── AWS Auth
     ├── Policy
     └── KV mount
             │
             ▼
       vault-secrets
             │
             ▼
       student01...student10
```

## Tests réalisés

- [x] Création du serveur Vault
- [x] Création de la workstation
- [x] Workstation → Vault via IP privée
- [x] PC → Vault via IP publique
- [x] Création du mount KV v2
- [x] Création des secrets étudiants
- [x] Configuration AWS Auth
- [x] Configuration de la policy Vault
- [x] Authentification AWS de la workstation auprès de Vault
- [x] Lecture d'un secret étudiant depuis la workstation
- [x] `credentials_mode = "vault"`
- [x] Récupération des credentials AWS par les étudiants
- [x] `terraform destroy` de `vault-config`
- [x] Recréation complète de la configuration Vault

## Ordre de destruction

Si Vault est encore disponible :

```text
1. vault-config
      ↓
terraform destroy

2. infrastructure
      ↓
terraform destroy
```

Si l'EC2 Vault a déjà été détruite, Vault n'est plus accessible. Dans ce cas, ne pas lancer `terraform destroy` dans `vault-config` : le state peut simplement être supprimé puisque les ressources Vault ont déjà disparu avec l'instance.

## Limites du POC

- Vault utilise le mode development.
- Le root token Vault est utilisé uniquement pour le POC.
- Les credentials des étudiants sont présents dans le state Terraform.
- Tous les utilisateurs Linux de la workstation utilisent la même identité IAM de workstation pour l'authentification AWS auprès de Vault.
- Le serveur Vault est éphémère.
- Le projet n'est pas destiné à la production.

## Objectif pédagogique

Ce POC montre comment Terraform peut orchestrer :

```text
Infrastructure
      +
IAM
      +
Workstation
      +
Vault
      +
Secrets
      +
Authentification AWS
      +
Configuration utilisateur
```

L'objectif est de montrer que Terraform peut gérer non seulement la création de ressources cloud, mais également l'enchaînement de composants et leurs dépendances.
