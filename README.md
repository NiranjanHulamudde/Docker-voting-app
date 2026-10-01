# Distributed Docker Voting Application & CI/CD Pipeline 

A microservices-based voting application featuring decoupled **Frontend** and **Backend** services. This repository includes the complete source code, automated test suites, a **Jenkins Declarative Pipeline** file for continuous integration/delivery, and **Terraform** configurations to provision the required cloud infrastructure automatically.

---

## 🚀 Architecture Overview

*   **Backend:** Python Flask microservice containing application logic and unit tests.
*   **Frontend:** Decoupled presentation layer served as an isolated container.
*   **CI/CD Engine:** Jenkins Declarative Pipeline automates validation, image multi-building, and cloud registry publishing.
*   **Infrastructure as Code (IaC):** Terraform configuration files to automate the provisioning of cloud hosting assets (AWS).

---

## 🛠️ Automated CI/CD Pipeline Stages

The included `Jenkinsfile` configures a 5-stage automated delivery lifecycle triggered on every repository commit:

1.  **Download and Check Source Code:** Clones and syncs the targeted Git branch context to the local workspace.
2.  **Running Tests:** Creates an isolated Python virtual environment, installs project dependencies (`flask`, `pytest`), and runs automated regression tests.
3.  **Building the Images:** Packages the frontend and backend architectures into separate Docker images tagged dynamically with the unique build runtime token (`v.${BUILD_NUMBER}`).
4.  **Pushing Images to Docker Hub:** Authenticates against a secure container registry configuration and pushes both production images to Docker Hub under the targeted namespace.
5.  **Infrastructure Provisioning:** Uses the environment's AWS access credentials to securely initialize Terraform, resolve target providers, and run an automated `terraform apply` deployment.

---

## ⚙️ Prerequisites & Setup

### 1. Required Credentials in Jenkins
To successfully execute this pipeline, ensure the following credentials are added to your Jenkins Credential Provider store:

| Credential ID | Type | Description |
| :--- | :--- | :--- |
| `docker-pass` | Username with Password | Your Docker Hub Registry login username and password. |
| `aws-access-key-id` | Secret Text | Your AWS Account Identity IAM access key string. |
| `aws-secret-access-key` | Secret Text | Your AWS Account Identity IAM secret passphrase key string. |

### 2. Host Machine Tooling Dependencies
The active Jenkins build runner agent requires the following system binary packages installed on its terminal path:
*   **Docker CE Engine** (`docker build`, `docker login`, `docker push` capability)
*   **Python 3 & pip** (`python3-venv` utility module installed for test sandboxing)
*   **Terraform CLI** (Initialized binary to execute plan applications)

---

## 📂 Project Directory Structure

```text
├── .git
├── Jenkinsfile                   # Validated CI/CD workflow script
├── README.md                     # Documentation summary
├── backend/                      # Python Flask app logic
│   ├── app.py                    # Main app source code & endpoint routines
│   ├── Dockerfile                # Backend containerization assembly steps
│   └── [requirements/tests...]   
├── frontend/                     # Application UI interface engine
│   └── Dockerfile                # Frontend web application server setup
└── terraform/                    # Infrastructure as Code parameters
    ├── main.tf                   # Main AWS resource definitions
    ├── variables.tf              # Configurable Terraform variable schemas
    └── provider.tf               # Cloud provider configurations
```

---

## 💻 Manual Local Development Execution

If you wish to test parts of the application locally outside of the Jenkins automation server:

### Run Backend Tests Manually
```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt flask pytest
python3 -m pytest app.py
```

### Local Docker Build Assemblies
```bash
# Build local validation configurations
docker build -t local-voting-backend:v1 ./backend
docker build -t local-voting-frontend:v1 ./frontend
```

### Local Infrastructure Checks
```bash
cd terraform
terraform init
terraform plan
```
