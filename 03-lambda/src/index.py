import boto3

client = boto3.client('ec2')

def get_cp_generic_dc_aws_security_groups():
    ips_by_sg = {}

    nics = client.describe_network_interfaces()

    for nic in nics['NetworkInterfaces']:
        for group in nic['Groups']:
            # print(group['GroupId'], group['GroupName'])
            for ip in nic['PrivateIpAddresses']:
                # print(ip)
                if ips_by_sg.get(group['GroupId']) is None:
                    ips_by_sg[group['GroupId']] = []
                if ips_by_sg.get(group['GroupName']) is None:
                    ips_by_sg[group['GroupName']] = []
                ips_by_sg[group['GroupId']].append(ip['PrivateIpAddress'])
                ips_by_sg[group['GroupName']].append(ip['PrivateIpAddress'])

    # print()
    # print(ips_by_sg)

    object_list = []
    for sg in ips_by_sg:
        object_list.append({
            "name": sg,
            "id": sg,
            "description": "Example for IPv4 addresses",
            "ranges": ips_by_sg[sg]
        })

    generic_dc_objects = {
        "version": "1.0",
        "description": "Generic Data Center file example",
        "objects": object_list
    }

    print(generic_dc_objects)

    # Example output per https://support.checkpoint.com/results/sk/sk167210:
    # {
    #     "version": "1.0",     
    #     "description": "Generic Data Center file example",
    #     "objects": [
    #                         {
    #                              "name": "Object A name",
    #                              "id": "e7f18b60-f22d-4f42-8dc2-050490ecf6d5",
    #                              "description": "Example for IPv4 addresses",
    #                              "ranges": [
    #                                                    "91.198.174.192",
    #                                                    "20.0.0.0/24",                        
    #                                                    "10.1.1.2-10.1.1.10"
    #                              ]              
    #                         },
    #                         {
    #                               "name": "Object B name",
    #                               "id": "a46f02e6-af56-48d2-8bfb-f9e8738f2bd0",
    #                               "description": "Example for IPv6 addresses",
    #                               "ranges": [
    #                                                    "2001:0db8:85a3:0000:0000:8a2e:0370:7334",
    #                                                    "0064:ff9b:0000:0000:0000:0000:1234:5678/96",
    #                                                    "2001:0db8:85a3:0000:0000:8a2e:2020:0-2001:0db8:85a3:0000:0000:8a2e:2020:5"                                        
    #                               ]
    #                         }
    #    ]
    # }

    return generic_dc_objects


def lambda_handler(event, context):
   message = 'Hello {} !'.format(event.get('key1'))
   return {
       'message' : message,
       'sgs': get_cp_generic_dc_aws_security_groups()
   }
