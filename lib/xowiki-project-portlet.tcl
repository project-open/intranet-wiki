# /packages/intranet-wiki/lib/xowiki-portlet.tcl
#
# Copyright (C) 2015 ]project-open[
#
# All rights reserved. Please check
# http://www.project-open.com/license/ for details.

# ----------------------------------------------------------------------
# Variables and Parameters
# ---------------------------------------------------------------------

# project_id:required
set finished_p 0
set html "xowiki-project-portlet: An error occured in this portlet, please notify your System Administrator."

# Check if the project exists
if {![db_0or1row project_info "
	select	project_name,
		project_nr
	from	im_projects
	where	project_id = :project_id	
"]} {
    set html "xowiki-project-portlet: Project #$project_id doesn't exist."
    set finished_p 1
    ad_return_template
}


# Check that the XoWiki package has been installed
set xowiki_exists_p [im_package_exists_p xowiki]
if {!$finished_p && !$xowiki_exists_p} { 
    set html "xowiki-project-portlet: XoWiki package has not been installed yet."
    set finished_p 1
    ad_return_template
}

# Check if the project-template already exists.
set project_template_id [db_string project_template "
	select	item_id
	from	cr_items
	where	content_type = '::xowiki::Page' and
		name = 'en:project-template'
" -default 0]
if {!$finished_p && 0 == $project_template_id} {
    set url "/xowiki/project-template"
    set html "<ul><li><a href=\"$url\"
    >[lang::message::lookup "" intranet-wiki.Need_to_create_project_template "You need to create a project template.<br>Just click on this link and then press 'Edit' to customize the template."]</a>
    </li></ul>"
    set finished_p 1
    ad_return_template 
}

# Check if the project-page already exists.
set name "en:$project_nr"
set project_page_id [db_string project_page "
	select	item_id
	from	cr_items
	where	content_type = '::xowiki::Page' and
		name = :name
" -default 0]
if {!$finished_p && 0 == $project_page_id} {
    set object_type "::xowiki::Page"
    set source_item_id $project_template_id
    set title $project_name
    set url [export_vars -base "/xowiki/" {object_type {edit-new 1} name source_item_id title}]

    set html "<ul><li><a href=\"$url\" target=\"_blank\"
    >[lang::message::lookup "" intranet-wiki.Need_to_create_project_page "No XoWiki page exists for your project '$project_nr' yet.<br>Please create one by clicking on this link."]</a>
    </li></ul>"
    set finished_p 1
    ad_return_template 
}

# Show the actual XoWiki Link
if {!$finished_p} {
    set url "/xowiki/$project_nr"

    set html "<ul><li><a href=\"$url\" target=\"_blank\"
    >[lang::message::lookup "" intranet-wiki.XoWiki_page_for_project_nr "See the XoWiki page for this project '$project_nr' - '$project_name'."]</a>
    </li></ul>"
    set finished_p 1
    ad_return_template 
}

