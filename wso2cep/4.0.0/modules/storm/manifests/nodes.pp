
node /nimbus/ {
	class { "storm::nimbus":
		version 		    		=> '0.9.5',
		owner               => 'root',
    group               => 'root',
    maintenance_mode		=> 'new',	
	}
}

node /zookeeper/ {
  class { "storm::zookeeper":
    version             => '0.9.5',
    owner               => 'root',
    group               => 'root',
    maintenance_mode    => 'new',  
  }
}

node /stormui/ {
  class { "storm::stormui":
    version             => '0.9.5',
    owner               => 'root',
    group               => 'root',
    maintenance_mode    => 'new',  
  }
}

node /supervisor/ {
  $supervisor = hiera("supervisor")
  class { "storm::supervisor":
    version                => '0.9.5',
    owner                  => 'root',
    group                  => 'root',
    maintenance_mode       => 'new',
    supervisor_slot_ports  => $supervisor[supervisor_slot_ports],
    worker_xmx             => $supervisor[worker_xmx],
    worker_xms             => $supervisor[worker_xms],
  }
}