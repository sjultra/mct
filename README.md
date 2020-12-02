# mct
The Muti-Cloud Test (MCT) code repository contains a set of Terraform deployment scripts that can be used in a DevOps pipeline to establish two parallel multi-cloud test labs.
This facilitates the set up, testing, and destruction of complete virtual environments. 
Each network security test lab environment incorporates three public cloud projects: Amazon AWS, Microsoft Azure, and Google Cloud Platform (GCP). 
A pair of external “Admin” virtual machines is used for running the setup and test scripts. 
This approach allows rapid iteration of the setup and testing steps using virtual machines and Kubernetes clusters with matching application services, network connections, and user access controls. 
