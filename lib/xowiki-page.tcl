# /packages/intranet-wiki/lib/xowiki-page.tcl
#
# Copyright (C) 2015 ]project-open[
#
# All rights reserved. Please check
# https://www.project-open.com/license/ for details.

# ----------------------------------------------------------------------
# Variables and Parameters
# ---------------------------------------------------------------------

# expects variables:
# - page
# - iframe_width
# - iframe_height


if {![info exists page]} { set page "/xowiki/index" }

set page_url [export_vars -base "/intranet-wiki/xowiki-page" {{page $page}}]
