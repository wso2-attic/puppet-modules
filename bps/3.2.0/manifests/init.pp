class bps (
  $version            = '1.1.0', 
  $s2_enabled         = true,
  $offset             = 0, 
  $localmember_port   = 4100, 
  $config_db          = 'governance', 
  $maintenance_mode   = true, 
  $depsync            = false, 
  $sub_cluster_domain = 'mgt',
  $owner              = 'root',
  $group              = 'root',
  $clustering         = 'true',
  $target             = '/mnt',
  $members            = {},
) inherits params{


  $deployment_code  = 'bps'
  $service_code     = 'bps'
  $carbon_home      = "${target}/wso2${service_code}-${version}"

  $service_templates  = [ 
    'conf/appfactory/endpoints/AppFactoryTenantInfraStructureInitializerService.epr', 
    'conf/appfactory/endpoints/AppFactoryTenantMgtAdminService.epr', 
    'conf/appfactory/endpoints/ApplicationDeployer.epr', 
    'conf/appfactory/endpoints/ApplicationManagementService.epr', 
    'conf/appfactory/endpoints/ArtifactCreator.epr', 
    'conf/appfactory/endpoints/ContinousIntegrationService.epr', 
    'conf/appfactory/endpoints/CustomLifecyclesChecklistAdminService.epr', 
    'conf/appfactory/endpoints/EmailSenderService.epr', 
    'conf/appfactory/endpoints/EventNotificationService.epr', 
    'conf/appfactory/endpoints/RepoManagementService.epr', 
    'conf/appfactory/endpoints/TenantMgtService.epr', 
    'conf/appfactory/endpoints/UserRegistrationService.epr', 
    'conf/carbon.xml',
    'conf/datasources.properties',
    'conf/datasources/bps-datasources.xml',
    'conf/email/invite-user-email-config.xml',
    'conf/sso-idp-config.xml',
    'wso2server.sh',
# BPS need a separate log4j file.
    'conf/log4j.properties',
  ]

  $common_templates   = [ 
    'conf/tenant-mgt.xml',
    'conf/user-mgt.xml',
    'conf/registry.xml',
    'conf/appfactory/appfactory.xml',
    'conf/datasources/master-datasources.xml',
  ]

  tag ($service_code)

  clean { $deployment_code:
    mode   => $maintenance_mode,
    target => $carbon_home,
  }

  initialize { $deployment_code:
    repo      => $package_repo,
    version   => $version,
    mode      => $maintenance_mode,
    service   => $service_code,
    local_dir => $local_package_dir,
    owner     => $owner,
    target    => $target,
    require   => Clean[$deployment_code],
  }

  deploy { $deployment_code:
    security  => true,
    owner     => $owner,
    group     => $group,
    target    => $carbon_home,
    require   => Initialize[$deployment_code],
  }

  if $sub_cluster_domain == 'worker' {
    createworker { $deployment_code:
      target  => $carbon_home,
      require => Deploy[$deployment_code],
    }
  } 

  file { "${carbon_home}/bin/wso2server.sh":
    ensure    => present,
    owner     => $owner,
    group     => $group,
    mode      => '0755',
    content   => template("${deployment_code}/wso2server.sh.erb"),
    require   => Deploy[$deployment_code],
  }
  push_templates { 
    $service_templates: 
      target    => $carbon_home,
      directory  => $deployment_code,
      require   => Deploy[$deployment_code];

    $common_templates:
      target    => $carbon_home,
      directory => 'wso2base',
      require   => Deploy[$deployment_code],
    }

  syslogng::createlog { 'Create BPS log':
    log_name        => $deployment_code,
    log_path        => "${carbon_home}/repository/logs/wso2carbon.log",
  }

  start { $deployment_code:
    owner   => $owner,
    target  => $carbon_home,
    require => [ Initialize[$deployment_code],
      Deploy[$deployment_code],
      Push_templates[$service_templates],
      Push_templates[$common_templates],
    ];
  }
}
