# /packages/intranet-wiki/lib/xowiki-portlet.tcl
#
# Copyright (C) 2015 ]project-open[
#
# All rights reserved. Please check
# https://www.project-open.com/license/ for details.

# ----------------------------------------------------------------------
# Variables and Parameters
# ---------------------------------------------------------------------

# conf_item_id:required
set finished_p 0
set html "xowiki-conf-item-portlet: An error occured in this portlet, please notify your System Administrator."

# Check if the conf_item exists
if {![db_0or1row conf_item_info "
	select	conf_item_name,
		conf_item_nr
	from	im_conf_items
	where	conf_item_id = :conf_item_id	
"]} {
    set html "xowiki-conf-item-portlet: Conf_Item #$conf_item_id doesn't exist."
    set finished_p 1
    ad_return_template
}


# Check that the XoWiki package has been installed
set xowiki_exists_p [im_package_exists_p xowiki]
if {!$finished_p && !$xowiki_exists_p} { 
    set html "xowiki-conf-item-portlet: XoWiki package has not been installed yet."
    set finished_p 1
    ad_return_template
}

# Check if the conf-item-template already exists.
set conf_item_template_id [db_string conf_item_template "
	select	item_id
	from	cr_items
	where	content_type = '::xowiki::Page' and
		name = 'en:conf-item-template'
" -default 0]
if {!$finished_p && 0 == $conf_item_template_id} {
    set url "/xowiki/conf-item-template"
    set html "<ul><li><a href=\"$url\"
    >[lang::message::lookup "" intranet-wiki.Need_to_create_conf_item_template "You need to create a conf_item template.<br>Just click on this link and then press 'Edit' to customize the template."]</a>
    </li></ul>"
    set finished_p 1
    ad_return_template 
}

# Check if the conf-item-page already exists.
set name "en:$conf_item_nr"
set conf_item_page_id [db_string conf_item_page "
	select	item_id
	from	cr_items
	where	content_type = '::xowiki::Page' and
		name = :name
" -default 0]
if {!$finished_p && 0 == $conf_item_page_id} {
    set object_type "::xowiki::Page"
    set source_item_id $conf_item_template_id
    set title $conf_item_name
    set url [export_vars -base "/xowiki/" {object_type {edit-new 1} name source_item_id title}]

    set html "<ul><li><a href=\"$url\" target=\"_blank\"
    >[lang::message::lookup "" intranet-wiki.Need_to_create_conf_item_page "No XoWiki page exists for your conf_item '$conf_item_nr' yet.<br>Please create one by clicking on this link."]</a>
    </li></ul>"
    set finished_p 1
    ad_return_template 
}

# Show the actual XoWiki Link
if {!$finished_p} {
    set url "/xowiki/$conf_item_nr"

    set html "<ul><li><a href=\"$url\" target=\"_blank\"
    >[lang::message::lookup "" intranet-wiki.XoWiki_page_for_conf_item_nr "See the XoWiki page for this conf_item '$conf_item_nr' - '$conf_item_name'."]</a>
    </li></ul>"
    set finished_p 1
    ad_return_template 
}

