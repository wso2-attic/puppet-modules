$common 	= hiera("nodeinfo")
$datasource = hiera("datasources")

node /hanode/ {
	$hanode = hiera("hanode")
	class { "cep::hanode":
		version 		    		        => $common[version],
		owner               		    => $common[owner],
    group               		    => $common[group],
    maintenance_mode			      => $common[maintenance_mode],
  	offset  		    		        => $hanode[offset],
  	clustering          		    => $hanode[clustering],
  	depsync						          => $hanode[depsync],
  	local_member_port   		    => $hanode[local_member_port],
  	membership_scheme   		    => $hanode[membership_scheme],
  	cluster_domain      		    => $hanode[cluster_domain],
  	members             		    => $hanode[members],
  	worker              		    => $hanode[worker],
  	presenter           		    => $hanode[presenter],
  	ha_eventsynch_port  		    => $hanode[ha_eventsynch_port],
  	ha_mgt_port         		    => $hanode[ha_mgt_port],
  	presenter_port 				      => $hanode[presenter_port],
  	registry_db_connection_url  => $datasource[registry_db_connection_url],
    registry_db_user            => $datasource[registry_db_user],
    registry_db_password        => $datasource[registry_db_password],
    registry_db_driver_name     => $datasource[registry_db_driver_name],
    userstore_db_connection_url	=> $datasource[userstore_db_connection_url],
    userstore_db_user           => $datasource[userstore_db_user],
    userstore_db_password       => $datasource[userstore_db_password],
    userstore_db_driver_name    => $datasource[userstore_db_driver_name],
	}
}

node /distributednode/ {
  $distributednode = hiera("distributednode")
  class { "cep::distributednode":
    version                     => $common[version],
    owner                       => $common[owner],
    group                       => $common[group],
    maintenance_mode            => $common[maintenance_mode],
    offset                      => $distributednode[offset],
    clustering                  => $distributednode[clustering],
    depsync                     => $distributednode[depsync],
    local_member_port           => $distributednode[local_member_port],
    membership_scheme           => $distributednode[membership_scheme],
    cluster_domain              => $distributednode[cluster_domain],
    members                     => $distributednode[members],
    worker                      => $distributednode[worker],
    presenter                   => $distributednode[presenter],
    manager_port                => $distributednode[manager_port],
    manager                     => $distributednode[manager],
    managers                    => $distributednode[managers],
    presenter_port              => $distributednode[presenter_port],
    topology_workers            => $distributednode[topology_workers],
    registry_db_connection_url  => $datasource[registry_db_connection_url],
    registry_db_user            => $datasource[registry_db_user],
    registry_db_password        => $datasource[registry_db_password],
    registry_db_driver_name     => $datasource[registry_db_driver_name],
    userstore_db_connection_url => $datasource[userstore_db_connection_url],
    userstore_db_user           => $datasource[userstore_db_user],
    userstore_db_password       => $datasource[userstore_db_password],
    userstore_db_driver_name    => $datasource[userstore_db_driver_name],
  }
}