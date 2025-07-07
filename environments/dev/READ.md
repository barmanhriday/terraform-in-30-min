Prerequisite preparation :
Let’s download the Terraform binary from its official site — hashicorp.com — and place it in C:\terraform. After that, add the path (C:\terraform) to the System Environment Variables to run terraform from any terminal.Although there are many ways to write Terraform code on Windows, Visual Studio Code is one of the best editors because of features like:
Error Detection & Inline Validation  Built-in Terminal,Easy Project & Folder ,Version Control Integration (Git),etc.
The following structure and code blocks are written and executed within Visual Studio Code.
For this project, we’ll use a project named “Demo”. 
All directories        (folder      + files        )   structure of the project is shown using the command: tree  /f .This command is executed on the Visual Studio Code terminal (v1.101.2) under the root directory,C:\demo


  
├───.terraform
│   └───providers
│       └───registry.terraform.io
│           └───hashicorp
│               └───aws
│                   └───6.0.0
│                       └───windows_386
│                               LICENSE.txt
│                               terraform-provider-aws_v6.0.0_x5.exe
│
├───environments
│   ├───dev
│   │   │   .terraform.lock.hcl
│   │   │   dev.tfvars
│   │   │   main.tf
│   │   │   terraform.tfstate
│   │   │   terraform.tfstate.backup
│   │   │   tfplan
│   │   │   variables.tf
│   │   │
│   │   └───.terraform
│   │       └───modules
│   │               modules.json
│   │
│   ├───prod
│   │   │   .terraform.lock.hcl
│   │   │   main.tf
│   │   │   terraform.tfstate
│   │   │   terraform.tfstate.backup
│   │   │   terraform.tfvars
│   │   │   variables.tf
│   │   │
│   │   └───.terraform
│   │       ├───modules
│   │       │       modules.json
│   │       │
│   │       └───providers
│   │           └───registry.terraform.io
│   │               └───hashicorp
│   │                   └───aws
│   │                       └───6.2.0
│   │                           └───windows_386
│   │                                   LICENSE.txt
│   │                                   terraform-provider-aws_v6.2.0_x5.exe
│   │
│   └───staging
│       │   .terraform.lock.hcl
│       │   main.tf
│       │   staging.tfvars
│       │   terraform.tfstate
│       │   terraform.tfstate.backup
│       │   variables.tf
│       │
│       └───.terraform
│           ├───modules
│           │       modules.json
│           │
│           └───providers
│               └───registry.terraform.io
│                   └───hashicorp
│                       └───aws
│                           └───6.2.0
│                               └───windows_386
│                                       LICENSE.txt
│                                       terraform-provider-aws_v6.2.0_x5.exe
│
└───module
    ├───ec2
    │       main.tf
    │       variables.tf
    │
    ├───s3
    │       main.tf
    │
    └──vpc
            main.tf
            output.tf

Pointer             is used to show the manual created directory.
Pointer            is used to show the manual created file under directories.
Without pointers all files are auto created upon execution of terraform.
Based on above tree ,now we can understand  the objective. In a workplace ,project manager assign terraform team  to create 3 resources .
1.An EC2 instance — with instance type varying per environment
2.A user-defined VPC + subnet — for secure and isolated networking
3.One S3 bucket — common  per environment.
To ensure safe testing and proper production deployment, the infrastructure is divided into 3 environments:
dev → used by developers (on low-cost EC2)
staging → used by QA team (on mid-cost EC2)
prod → used by project manager for real use (on high-end EC2)
Let's break down  Terraform project tree and explain the purpose of each file step by step. . Please refer the pointers / and pointer’s colour from tree.

provider "aws" { # first thing is to mention provider, which is aws in 
                 #this case
  region = "us-east-1" /*
  Region: us-east-1 (can be changed as needed).
  Make sure all resources are deployed in the same region to avoid cross-region issues.Objective: We are creating three resources — EC2, VPC, and S3 — each defined as a separate Terraform resource.
  Module Structure:
  - Each resource is placed in its own module: `ec2`, `vpc`, and `s3`.
  - Using modules allows us to reuse code efficiently across multiple environments (dev, stag, prod).
  - This modular approach improves code readability, maintainability, and reduces duplication.*/
}
module "ec2"{ #  under aws provider mentioning module ec2,a ref name only
  source        = "../../module/ec2" #this is the path to ec2 which # # # will be changed in every environment
  instance_type = var.instance_type # launching ec2 always require instance type
  # we need variable instance type as per different environment 
  subnet_id     = module.vpc.subnet_id # user define subnet will be #created under user define VPC
   
  vpc_id        = module.vpc.vpc_id # module vpc will create which vpc name 
  #we will assign with user defines cidr
}
module "vpc" {# VPC module declaration
  source = "../../module/vpc"  # path to the vpc module
}
module "s3" { # s3 module declaration 
  source = "../../module/s3" # path to the s3 module
}# opening and closing  bracket needs in every #module ,resources,variables etc
Now,it’s time to search the module information initialization terraform main.tf (heart of terraform) under dev .First thing , terraform will search what type of ec2 is ?????


resource "aws_instance" "kuch_bi" { #under ec2-main.tf ,we decare 
  #aws_instance  kuch_bi is the name of the resource, it can be 
  #anything .
  ami           = "ami-05ffe3c48a9991133"  # Replace with a real AMI ID
  instance_type = var.instance_type # still variable based instance 
  #because of different environment,we will specify actual instance ##type on environment only
  subnet_id     = var.subnet_id # define in vpc module
  tags = {
  Name = "kuch-bi-${terraform.workspace}"# Naming the resource 
    #dynamically using the current Terraform workspace.
  }
}
Now,as ec2 execution is dependent on variables,let go the variable.tf file under ec2 directory
variable "instance_type" {
  description = "EC2 instance type"
  type        = string # variables will be called
  # in environment only as per environment
}
variable "subnet_id" {
  description = "Subnet ID to launch the EC2 in"
  type        = string# variables will be called
  # in vpc module only
}
variable "vpc_id" {
  type = string# variables will be called
  # in vpc module  only
}
Now,it’s time to search next module information .next  terraform will search what type of vpc is 

resource "aws_vpc" "ref_name_only" { # ref_name_only 
  cidr_block = "10.0.0.0/16" # user defined block
  tags = {
    Name = "MyVPC" #name of vpc
  }
}

resource "aws_subnet" "my_subnet" {# defining subnet ref
  vpc_id            = aws_vpc.ref_name_only.id # MyVPC will 
  # be taken in auto mode from previous code
  cidr_block        = "10.0.1.0/24" # user define lower ip range
  availability_zone = "us-east-1a" # AZ

  tags = {
    Name = "MySubnet"# name of the subnet
  }
}

Now,it’s time to search next module information .next  terraform will search what type of s3 is 
resource "aws_s3_bucket" "only_ref_name" { # resource 
# declaration 
  bucket = "my-noida-bucket" #name of the bucket
  #there is no variable at all 
  #we create a simple bucket  with ACL parameters
 }
resource "aws_s3_bucket_public_access_block" "ref_name" { #ACL
  bucket = aws_s3_bucket.only_ref_name.id

  block_public_acls       = true # access block
  block_public_policy     = true # access block
  ignore_public_acls      = true # access block
  restrict_public_buckets = true # access block
}
Resource declaration is over ,now lets go the environments with carrying  all variables mentioned in module. Under \dev environments ,main.tf got vpc and s3 value ,but still finding what value for ec2 type.


variable "instance_type" { # this value will be defined in
#.tfvar file with actual value as per enviroment
# subnet and vpc already known and hence  no need to mention  
# again
  description = "EC2 instance type"
  type        = string # any character 
}


Now,finally final.tf call dev.tfvars for ec2 type ,if we name it terraform.tfvars then on initialization.Terraform will not asks for instance type,otherwise we need to fill up on initialization.
instance_type = "t1.micro" # assigning t1.micro only for dev env



Above pointers are applied to other two environments also with same coding ,only the instance_type will be changed in  .tfvars file .On Stag environment we assign a medium size ec2 “t2.micro” and on production environment we use “ t2.small “.
Let's run the code in the terminal.
Oh no!!!! Before Terraform can interact with AWS, we need to provide our AWS credentials. Run the following command in the terminal:
You will be prompted to enter the following details. You can skip the output format by simply pressing Enter.

AWS Access Key ID
AWS Secret Access Key
Default region name (in my case it’s : us-east-1)
Default output format — lets skip this for now
We're now ready to perform actions with Terraform. Here are the four essential commands to get started: We will run dev environment first on root directory/environment/dev…
1 .terraform init – Initializes the working directory and downloads necessary provider plugins.
2.terraform plan – Shows the execution plan and what Terraform intends to do.
3.terraform apply – Applies the changes required to reach the desired state of the configuration.
4.terraform destroy -destroy all resources immediately ,best practice for learning to avoid unnecessary billing 
  
Lets clear the terminal scree with “clear” command and run terraform plan.
As I said earlier, terraform will ask instance type ,We make it t1.micro .


Five resources are added in planning .
1.EC2 Instance
Type: aws_instance
Module: module.ec2
Name: kuch_bi
Purpose: Creates the EC2 virtual machine using the specified AMI and instance type.
2. S3 Bucket
Type: aws_s3_bucket
Module: module.s3
Name: only_ref_name
Purpose: Creates an S3 bucket named my-noida-bucket for storage.
3. S3 Bucket Public Access Block
Type: aws_s3_bucket_public_access_block
Module: module.s3
Name: ref_name
Purpose: Ensures the S3 bucket is not publicly accessible by blocking public ACLs and policies.
4.Subnet
Type: aws_subnet
Module: module.vpc
Name: my_subnet
Purpose: Creates a subnet inside the VPC for the EC2 instance to launch into (CIDR: 10.0.1.0/24).
5. VPC
Type: aws_vpc
Module: module.vpc
Name: ref_name_only
Purpose: Creates a Virtual Private Cloud with CIDR block 10.0.0.0/16.
Ok ..looks everything works as our plan.It’s time to  apply code on production environment with predefined t1.small instance,this time we will use .tfvar variable on terminal itself,so that terraform will understand the instance type from code itself.
PS C:\demo\environments\dev> terraform apply -var-file="dev.tfvars"
Terraform will perform the actions described above. Press Yes and Enter.








Terminal is showing Apply complete. Now, let’s head over to the AWS Management Console to verify the resources (like EC2 instance, VPC, subnet, S3 bucket, etc.) have been created as defined in Terraform code.








Let’s Destroy the Infrastructure  by “terraform destroy” command to Avoid AWS Charges.Terraform will begin tearing down all the resources it previously created.
