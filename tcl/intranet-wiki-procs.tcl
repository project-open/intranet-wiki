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
    set result ""
    append result [im_wiki_base_component "" 0]
    return $result
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
    append result [im_wiki_base_component im_project $project_id]
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

    append result [im_wiki_base_component im_company $company_id]
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

    append result [im_wiki_base_component im_conf_item $conf_item_id]
    return $result
}


ad_proc im_wiki_office_component { office_id } {
    Wiki component to be shown at the system home page
} {
    # XoWiki component for offices not implemented yet
    set result ""

    append result [im_wiki_base_component im_office $office_id]
    return $result
}


ad_proc im_wiki_user_component { user_id } {
    Wiki component to be shown at the system home page
} {
    # XoWiki component for users not implemented yet
    set result ""
    append result [im_wiki_base_component user $user_id]
    return $result
}


ad_proc im_wiki_base_component { object_type object_id } {
    Wiki component to be shown at the system home page
} {
    if {![im_package_exists_p wiki]} { return "" }

    set folder_id [wiki::get_folder_id]
    set user_id [auth::require_login]
    set colspan 1

    # Get the list of currently existing Wiki installations
    set wikis_sql "
        select
                ap.package_id,
                cf.folder_id,
                ap.instance_name as wiki_title,
                sn.name as wiki_mount
        from
                apm_packages ap,
                cr_folders cf,
                site_nodes sn
        where
                ap.package_key = 'wiki'
                and cf.package_id = ap.package_id
                and sn.object_id = ap.package_id
                and 't' = acs_permission__permission_p(ap.package_id, :user_id, 'read')
    "

    set object_name [db_string object_name_for_one_object_id "" -default ""]
    set object_name_mangled [ns_urlencode $object_name]

    set ctr 0
    set wikis_html "<ul>"
    db_foreach wikis $wikis_sql {

        incr ctr
        append wikis_html "<hr><b>Deprecated: Old $wiki_title</b><br>\n"

        if {0 != $object_id} {
            append wikis_html "<li><A href=\"/$wiki_mount/$object_name_mangled\">$object_name</A>\n"
        }

        append wikis_html "
                <li><A href=\"/$wiki_mount/index\">[lang::message::lookup "" intranet-wiki.Main_Index "Main Index"]</A></li>
                <li><A href=\"/$wiki_mount/Category\">[lang::message::lookup "" intranet-wiki.Categories Categories]</A></li>
        "

        set admin_p [permission::permission_p \
                -object_id $package_id \
			 -party_id [ad_conn user_id] \
                -privilege "admin"
		     ]

        if {$admin_p} {
            append wikis_html "<li><A href=\"/intranet/admin/permissions/one?object_id=$package_id\">
                [lang::message::lookup "" intranet-wiki.Admin_Wiki_Permissions "Admin Wiki Permissions"]
            </A></li>\n"
            append wikis_html "<li><A href=\"/$wiki_mount/admin/index?folder_id=$folder_id&modified_only=1\">
                [lang::message::lookup "" intranet-wiki.Admin_Wiki_Changes "Admin Wiki Changes"]
            </A></li>\n"
            append wikis_html "<li><A href=\"/$wiki_mount/admin/index?folder_id=$folder_id\">
                [lang::message::lookup "" intranet-wiki.Admin_All_Pages "Admin All Pages"]
            </A></li>\n"
        }
        append wikis_html "<p></p>\n"
    }

    append wikis_html "</ul>"

    # Skip the component if there is no Wiki
    if {0 == $ctr} { return "" }

    append wikis_html "<br>Please tell your system administrator to 
    go to /acs-admin/apm/ and to delete the package 'Wiki' in order 
    to delete this deprecated version of the wiki. This old 'wiki' 
    has been replaced by 'XoWiki'. Please migrate existing 'wiki' 
    pages to the new 'XoWiki'."

    return $wikis_html
}
