Currently I am defining the cluster and tasks via the console and this is just to work on the service orchestration and elb attachment.
Later the task definitions will be added in.

To add instances to a cluster, I need to create the cluster as shown here,
https://www.terraform.io/docs/providers/aws/r/ecs_cluster.html

Then use this to launch instances.  With the specific IAM role they will be added to the default cluster (if it exists?)
http://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html

In order to add to a different cluster, put this in the user data init script
#!/bin/bash
echo ECS_CLUSTER=your_cluster_name >> /etc/ecs/ecs.config
