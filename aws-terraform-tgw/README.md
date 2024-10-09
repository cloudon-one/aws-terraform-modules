# AWS Transit Gateway Terraform Module

This Terraform module creates and manages an AWS Transit Gateway, including VPC attachments and route configurations.

## Features

- Create an AWS Transit Gateway
- Attach a VPC to the Transit Gateway
- Configure routes in the Transit Gateway route table

## Usage

```hcl
module "transit_gateway" {
  source = "./path/to/this/module"

  name        = "my-transit-gateway"
  description = "My Transit Gateway"

  vpc_attachments = [
    {
      vpc_id     = "vpc-1234567890abcdef0"
      subnet_ids = ["subnet-1234567890abcdef0", "subnet-0fedcba0987654321"]
      tgw_routes = [
        {
          destination_cidr_block = "10.0.0.0/16"
        },
        {
          destination_cidr_block = "172.16.0.0/12"
        }
      ]
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the Transit Gateway | `string` | n/a | yes |
| description | Description of the Transit Gateway | `string` | n/a | yes |
| vpc_attachments | List of VPC attachments configurations | `list(object)` | n/a | yes |

The `vpc_attachments` list should contain a single object with the following structure:

```hcl
{
  vpc_id     = string
  subnet_ids = list(string)
  tgw_routes = list(object({
    destination_cidr_block = string
  }))
}
```

## Resources Created

- `aws_ec2_transit_gateway`: The Transit Gateway itself
- `aws_ec2_transit_gateway_vpc_attachment`: VPC attachment to the Transit Gateway
- `aws_ec2_transit_gateway_route`: Routes in the Transit Gateway route table

## Notes

1. This module creates a single Transit Gateway with one VPC attachment.
2. Routes are added to the default route table of the Transit Gateway.
3. The module uses the first (and only) element of the `vpc_attachments` list for configuration.

## Limitations

1. This module supports only one VPC attachment. For multiple attachments, you would need to modify the module.
2. The module uses the default route table of the Transit Gateway. If you need custom route tables, you'll need to extend the module.
3. Advanced Transit Gateway features like multicast or cross-account attachments are not supported in this version of the module.
4. The module doesn't handle the creation of the VPC or subnets. These need to be created separately and referenced in the module inputs.

## Outputs

This module doesn't define any outputs. Consider adding outputs for the Transit Gateway ID, VPC attachment ID, or other relevant information if needed for your use case.

## License

This module is open-source software licensed under the [MIT license](https://opensource.org/licenses/MIT).