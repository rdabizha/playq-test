# playq-test
playq-terraform test project

PlayQ Engineering Exercise

The questions below reflect some of the key roles and responsibilities you will be asked to
execute and perform here on the Engineering team here at PlayQ. Once you review and
complete the exercise below, please share your answers in the form of a link to your public
GitHub repo.
Instructions:
The goal of this exercise is to use Terraform to provision an AWS Autoscaling Group, and
Application Load Balancer in AWS us-east-1 region. All instances created by the autoscaling
group should have some security group rules defined below and also bootstrap using the
userdata.sh file. You can use any flavor of Linux for your instances but pay close attention to
requirements related to being able to find the correct AMI based on the AWS region.
The end result should be a public GitHub repo with four files:
  ● loadbalancer.tf
  ● autoscaling.tf
  ● userdata.sh
  ● variables.tf
You should be able to find documentation for both Terraform and AWS through Google but these
links might be useful in getting started:
  ● Terraform AWS Provider Docs: Terraform Registry
  ● AWS Guides and API References: https://docs.aws.amazon.com/#lang/en_us
When writing the Terraform code it might be a good idea to test your code. Everything in this
challenge should be within AWS’s free tier of services for new accounts. If you wish to test your
code before submitting it sign up for a new AWS account.
The following are requirements for the deployment:
● All instances created by the Autoscaling Group should
  ○ Use an SSH key pair named “webservers”
  ○ Have a “Name” tag with a value of “PlayQ-2019”
  ○ Have a “Type” tag with a value of “webserver”
  ○ Use the “t2.micro” instance type
  ○ Set the user_data of the instance to the userdata.sh file content (see below)
  ○ Attach a security group (see below)

● The Autoscaling Group and Launch Template should
  ○ Choose the correct AMI based upon the region it’s launching into (hint: the
  Terraform “lookup” interpolation function will help)
  ○ Have a “Name” tag with a value of “PlayQ-2019”
  ○ Have a “Type” tag with a value of “webserver”
● The Application Load Balancer should:
  ○ Return a fixed 500 code by default
  ○ Use the host header to direct requests for the DNS name of the load balancer to
  the Auto Scaling Group instances
  ○ Attach a security group (see below)
● The Security Group for the instances should
  ○ Allow inbound SSH from your IP
  ○ Allow inbound SSH from 76.169.181.157
  ○ Secure the instances appropriately
● The Security Group for the Load Balancer should
  ○ Allow inbound HTTP from everywhere
  ○ Allow all outbound traffic to everywhere
● The userdata.sh Script should
  ○ Use the appropriate package manager to install the apache2 webserver
  ○ Setup an index.html for apache to server that says “Hello World from PlayQ Test”
  You should then be able to test if your infrastructure is working by navigating to the DNS name of
  your load balancer in a browser. You should see your “Hello World from PlayQ Test” page load.
