This automation script facilitates the deployment of Cisco Viptela components—such as vManage, vSmart, vBond, and vEdge—in the Azure cloud environment.
Deployment Steps:
A. In the root provider file, add your Azure credentials, including:
Application Secret
Tenant ID
Subscription ID
(Ensure these are securely managed.)
B. In the .tfvars file, provide details for the  username, Subnets, Vnet and password.
C. Specify the hostnames and organization ID to configure certificates. These will be used later to authorize the SD-WAN components.
D. Run the following Terraform commands to initiate the deployment:
terraform init 
terraform plan
terraform apply
