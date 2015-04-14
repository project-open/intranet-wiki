# /packages/intranet-wiki/lib/xowiki-portlet.tcl
#
# Copyright (C) 2015 ]company-open[
#
# All rights reserved. Please check
# http://www.company-open.com/license/ for details.

# ----------------------------------------------------------------------
# Variables and Parameters
# ---------------------------------------------------------------------

# company_id:required
set finished_p 0
set html "xowiki-company-portlet: An error occured in this portlet, please notify your System Administrator."

# Check if the company exists
if {![db_0or1row company_info "
	select	company_name,
		company_path
	from	im_companies
	where	company_id = :company_id	
"]} {
    set html "xowiki-company-portlet: Company #$company_id doesn't exist."
    set finished_p 1
    ad_return_template
}


# Check that the XoWiki package has been installed
set xowiki_exists_p [im_package_exists_p xowiki]
if {!$finished_p && !$xowiki_exists_p} { 
    set html "xowiki-company-portlet: XoWiki package has not been installed yet."
    set finished_p 1
    ad_return_template
}

# Check if the company-template already exists.
set company_template_id [db_string company_template "
	select	item_id
	from	cr_items
	where	content_type = '::xowiki::Page' and
		name = 'en:company-template'
" -default 0]
if {!$finished_p && 0 == $company_template_id} {
    set url "/xowiki/company-template"
    set html "<ul><li><a href=\"$url\"
    >[lang::message::lookup "" intranet-wiki.Need_to_create_company_template "You need to create a company template.<br>Just click on this link and then press 'Edit' to customize the template."]</a>
    </li></ul>"
    set finished_p 1
    ad_return_template 
}

# Check if the company-page already exists.
set name "en:$company_path"
set company_page_id [db_string company_page "
	select	item_id
	from	cr_items
	where	content_type = '::xowiki::Page' and
		name = :name
" -default 0]
if {!$finished_p && 0 == $company_page_id} {
    set object_type "::xowiki::Page"
    set source_item_id $company_template_id
    set title $company_name
    set url [export_vars -base "/xowiki/" {object_type {edit-new 1} name source_item_id title}]

    set html "<ul><li><a href=\"$url\" target=\"_blank\"
    >[lang::message::lookup "" intranet-wiki.Need_to_create_company_page "No XoWiki page exists for your company '$company_path' yet.<br>Please create one by clicking on this link."]</a>
    </li></ul>"
    set finished_p 1
    ad_return_template 
}

# Show the actual XoWiki Link
if {!$finished_p} {
    set url "/xowiki/$company_path"

    set html "<ul><li><a href=\"$url\" target=\"_blank\"
    >[lang::message::lookup "" intranet-wiki.XoWiki_page_for_company_path "See the XoWiki page for this company '$company_path' - '$company_name'."]</a>
    </li></ul>"
    set finished_p 1
    ad_return_template 
}

