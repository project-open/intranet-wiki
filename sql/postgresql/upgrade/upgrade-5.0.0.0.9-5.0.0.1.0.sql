-- upgrade-5.0.0.0.9-5.0.0.1.0.sql
SELECT acs_log__debug('/packages/intranet-wiki/sql/postgresql/upgrade/upgrade-5.0.0.0.9-5.0.0.1.0.sql','');

update im_menus
set visible_tcl = '[im_package_exists_p xowiki]'
where visible_tcl = '[im_package_exists xowiki]';


update im_menus
set visible_tcl = '[im_package_exists_p wiki]'
where visible_tcl = '[im_package_exists wiki]';

