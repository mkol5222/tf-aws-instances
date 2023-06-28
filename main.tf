module "vpc" {
    source = "./01-vpc"

    environment = "lab1"
    vpc_cidr = "10.42.0.0/16"

    public_subnets_cidr = ["10.42.11.0/24"]

    region = var.region
    availability_zones = ["${var.region}a"]
}

module "linux1" {
    source = "./02-linux"
    depends_on = [ module.vpc ]

    environment= "lab1-vm1"
    vpc_id = module.vpc.vpc_id
    subnet_id = module.vpc.public_subnet_id
    allow_src_cidr = var.allow_src_cidr
    
    security_group_id = module.vpc.default_security_group_id
}

module "linux2" {
    source = "./02-linux"
    depends_on = [ module.vpc ]

    environment= "lab1-vm2"
    vpc_id = module.vpc.vpc_id
    subnet_id = module.vpc.public_subnet_id
    allow_src_cidr = var.allow_src_cidr

    security_group_id = module.vpc.default_security_group_id
}