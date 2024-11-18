#!/bin/bash

chown -R www-data:www-data $DATA $HTDOCS
cd $HTDOCS/installer

if [ -d $DATA/.dada_files ]; then
	sleep 5
	sudo -u www-data ./install.cgi \
		--dada_files_loc $DATA \
		--upgrading || exit 1cd $HTDOCS && \
		cd $HTDOCS && test -d installer && mv installer installer-disabled
else
	sleep 15
	sudo -u www-data ./install.cgi \
		--program_url $DADA_URL/mail.cgi \
		--dada_root_pass $DADA_ROOT_PASSWORD \
		--dada_files_loc $DATA \
		--support_files_dir_path $HTDOCS/dada_mail_support_files \
		--support_files_dir_url $DADA_URL/dada_mail_support_files/ \
		--backend mysql \
		--sql_server mysql \
		--sql_port 3306 \
		--sql_database dada \
		--sql_username dada \
		--sql_password "dada_dada" \
		--install_plugins mailing_monitor \
		--install_plugins change_root_password \
		--install_plugins screen_cache \
		--install_plugins log_viewer \
		--install_plugins tracker \
		--install_plugins multiple_subscribe \
		--install_plugins blog_index \
		--install_plugins bridge \
		--install_plugins change_list_shortname \
		--install_wysiwyg_editors ckeditor \
		--wysiwyg_editor_install_ckeditor \
		--wysiwyg_editor_install_tiny_mce \
		--file_browser core5_filemanager && cd $HTDOCS && \
			test -d installer && mv installer installer-disabled
	if [ -d $HTDOCS/installer ]; then
		echo "Installer still enabled. This should not happen."
 		rm -rf $DATA/.dada_files
		exit 1
	fi
fi

cron && apachectl -D FOREGROUND