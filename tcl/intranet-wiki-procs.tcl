# /tcl/intranet-wiki-procs.tcl

ad_library {
    Wiki Interface Library
    @author frank.bergmann@project-open.com
    @creation-date  27 April 2005
}


ad_proc im_wiki_home_component { } {
    Wiki component to be shown at the system home page
} {
    # Wiki home component does't make any sense anymore
    return ""

    return [im_wiki_base_component "" 0]
}


ad_proc im_wiki_project_component { project_id } {
    Wiki component to be shown at the system home page
} {
    set result ""
    if {[im_package_exists_p xowiki]} {
	set params [list \
			[list project_id $project_id] \
	]
	append result [ad_parse_template -params $params "/packages/intranet-wiki/lib/xowiki-project-portlet"]
    }
    if {[im_package_exists_p wiki]} {
	append result [im_wiki_base_component im_project $project_id]
    }
    return $result
}

ad_proc im_wiki_company_component { company_id } {
    Wiki component to be shown at the system home page
} {
    set result ""
    if {[im_package_exists_p xowiki]} {
	set params [list \
			[list company_id $company_id] \
	]
	append result [ad_parse_template -params $params "/packages/intranet-wiki/lib/xowiki-company-portlet"]
    }
    if {[im_package_exists_p wiki]} {
	append result [im_wiki_base_component im_company $company_id]
    }
    return $result
}

ad_proc im_wiki_conf_item_component { conf_item_id } {
    Wiki component to be shown at the system home page
} {
    set result ""
    if {[im_package_exists_p xowiki]} {
	set params [list \
			[list conf_item_id $conf_item_id] \
	]
	append result [ad_parse_template -params $params "/packages/intranet-wiki/lib/xowiki-conf-item-portlet"]
    }
    if {[im_package_exists_p wiki]} {
	append result [im_wiki_base_component im_conf_item $conf_item_id]
    }
    return $result
}


ad_proc im_wiki_office_component { office_id } {
    Wiki component to be shown at the system home page
} {
    # XoWiki component for offices not implemented yet
    return ""

    return [im_wiki_base_component im_office $office_id]
}


ad_proc im_wiki_user_component { user_id } {
    Wiki component to be shown at the system home page
} {
    # XoWiki component for users not implemented yet
    return ""
}

