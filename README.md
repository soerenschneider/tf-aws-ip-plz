# tf-aws-ip-plz

![gitleaks](https://github.com/soerenschneider/tf-aws-ip-plz/actions/workflows/gitleaks.yaml/badge.svg)
![lint-workflow](https://github.com/soerenschneider/tf-aws-ip-plz/actions/workflows/lint.yaml/badge.svg)
![security-workflow](https://github.com/soerenschneider/tf-aws-ip-plz/actions/workflows/security.yaml/badge.svg)

This repository implements Infrastructure as Code (IaC) using [OpenTofu](https://opentofu.org/) to configure all resources necessary to run the [ip-plz](https://github.com/soerenschneider/ip-plz) service.

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)

## Getting Started

Follow these instructions to set up the repository and start managing your AWS and Vault resources.

### Prerequisites

- AWS account and appropriate permissions
- [OpenTofu](https://opentofu.org/)
- Terragrunt

### Running the code

1. **Clone the repository:**
   ```bash
   git clone https://github.com/soerenschneider/tf-aws-ip-plz.git
   cd tf-aws-ip-plz
   ```

2. **Provisioning resources:**
   ```bash
   cd envs/dev
   bash run.sh
   ```
