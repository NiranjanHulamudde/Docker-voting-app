# CI/CD Docker Pipeline with VirtualBox

A CI/CD pipeline designed to build, test, and automatically push Docker images to Docker Hub using a self-hosted runner environment running on VirtualBox.

## 🚀 Features
* Automated Docker builds triggered on code push.
* Multi-stage build caching for faster CI/CD execution.
* Self-hosted runner integration on isolated Linux environments.

## 🛠️ Prerequisites
Before running the pipeline locally or on a custom runner, ensure the following are installed:
* **VirtualBox** (7.x or higher)
* **Docker Engine** (24.x or higher)
* **Git**

## 💻 Local Setup & Configuration

1. **Clone the repository:**
   ```bash
   git clone https://github.com
   cd YOUR_REPO_NAME
   ```

2. **Verify Network Connectivity:**
   Ensure your environment can communicate with Docker Hub's registry on ports 80 and 443:
   ```bash
   nc -zv registry-1.docker.io 443
   ```

3. **Authenticate with Docker Hub:**
   ```bash
   echo "YOUR_PASSWORD_OR_TOKEN" | docker login -u USER_NAME --password-stdin
   ```


## Screenshots
Jenkins
<img width="1189" height="520" alt="Screenshot from 2026-09-09 20-56-19" src="https://github.com/user-attachments/assets/ec6604b6-9466-44ff-a4fb-16a07a9f1fae" />

Docker-Hub
<img width="965" height="452" alt="Screenshot from 2026-09-09 20-55-22" src="https://github.com/user-attachments/assets/822444c5-ffe2-44ed-9835-ca4f754cb7d0" />

