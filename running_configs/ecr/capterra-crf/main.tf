resource "aws_ecr_repository" "repo" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
  }

  tags = {
    repository = lower(var.github_repository_oidc_access)
    team       = lower(var.team_sso_access)
  }
}


resource "aws_ecr_lifecycle_policy" "autoclean" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep crf-api-pr for 10 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["crf-api-pr-"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep crf-xavier-pr for 10 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["crf-xavier-pr-"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 3,
            "description": "Keep crf-webapp-pr for 10 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["crf-webapp-pr-"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 4,
            "description": "Keep crf-data-highway-pr for 10 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["crf-data-highway-pr-"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 5,
            "description": "Keep crf-mailer-pr for 10 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["crf-mailer-pr-"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 6,
            "description": "Keep crf-api-v for 60 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["crf-api-v"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 60
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 7,
            "description": "Keep crf-xavier-v for 60 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["crf-xavier-v"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 60
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 8,
            "description": "Keep crf-webapp-v for 60 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["crf-webapp-v"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 60
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 9,
            "description": "Keep crf-data-highway-v for 60 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["crf-data-highway-v"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 60
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 10,
            "description": "Keep crf-mailer-v for 60 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["crf-mailer-v"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 60
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 11,
            "description": "Keep untagged for 1 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
