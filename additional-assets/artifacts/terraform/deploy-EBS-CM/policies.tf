############################################
# Create Policies
############################################

resource "oci_identity_policy" "network_administrator_policy" {
  name           = "network_administrator_policy"
  description    = "Policy to govern access to network compartment for network administrators, EBS Cloud Manager and EBS HOL DBAs"
  compartment_id = "${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.id}"

  statements = ["Allow group ${oci_identity_group.network_administrators_group.name} to manage virtual-network-family in compartment  ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}",
  "Allow group ${oci_identity_group.ebs_cm_administrators_group.name} to use virtual-network-family in compartment  ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}",
  "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to use virtual-network-family in compartment  ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}",
  ]
}

resource "oci_identity_policy" "ebs_hol_tenancy_level_policy" {
  name           = "ebs_hol_tenancy_level_policy"
  description    = "Policy to govern EBS HOL DBAs access at tenancy level"
  compartment_id = "${var.tenancy_ocid}"

  statements = ["Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to manage buckets in tenancy",
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to manage objects in tenancy",
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to manage app-catalog-listing in tenancy",
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to inspect compartments in tenancy",
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to inspect groups in tenancy",
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to inspect users in tenancy",
    "Allow group ${oci_identity_group.network_administrators_group.name} to inspect compartments in tenancy",
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to use tag-namespaces in tenancy where target.tag-namespace.name='Oracle-Tags'",  
  ]
}

resource "oci_identity_policy" "ebs_hol_cm_admins_policy" {
  name           = "ebs_hol_cm_admins_policy"
  description    = "Policy to govern access to the Cloud Manager Compartment for EBS Cloud Manager Admins"
  compartment_id = "${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.id}"

  statements = ["Allow group ${oci_identity_group.ebs_cm_administrators_group.name} to manage instance-family in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}",
    "Allow group ${oci_identity_group.ebs_cm_administrators_group.name} to manage load-balancers in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}",  
    "Allow group ${oci_identity_group.ebs_cm_administrators_group.name} to manage tag-namespaces in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}",  
  ]
}

resource "oci_identity_policy" "ebs_hol_dbas_policy" {
  name           = "ebs_hol_dbas_policy"
  description    = "Policy to govern access to the Cloud Manager Compartment for EBS DBAs"
  compartment_id = "${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.id}"

  statements = ["Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to manage instance-family in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}",
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to manage database-family in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}", 
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to manage load-balancers in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}", 
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to manage volume-family in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}", 
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to use tag-namespaces in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}",    
  ]
}


/*resource "oci_identity_policy" "ebs_hol_dbas_on_policy" {
  name           = "ebs_hol_dbas_policy"
  description    = "Policy to govern access to EBS HOL Compartment for EBS HOL DBAs"
  compartment_id = "${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.id}"

  statements = ["Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to manage instance-family in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}",
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to manage database-family in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}", 
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to manage load-balancers in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}", 
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to manage volume-family in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}",
    "Allow group ${oci_identity_group.ebs_hol_dbas_group.name} to use tag-namespaces in compartment ${data.oci_identity_compartments.ebs_hol_compartment.compartments.0.name}",
  ]
}*/


