#!/bin/bash -l
shopt -s expand_aliases
source ~/.bash_aliases

echo $PWD
publish_gem

for i in cmor-blog cmor-blog-api cmor-carousels cmor-carousels-api cmor-cms cmor-cms-api cmor-contact cmor-contact-api cmor-core cmor-core-api cmor-core-api-backend cmor-core-backend cmor-core-frontend cmor-core-settings cmor-files cmor-files-api cmor-galleries cmor-galleries-api cmor-legal cmor-legal-api cmor-links cmor-links-api cmor-multi_tenancy cmor-partners cmor-partners-api cmor-seo cmor-seo-api cmor-showcase cmor-showcase-api cmor-system cmor-tags cmor-tags-api cmor-testimonials cmor-testimonials-api cmor-user_area cmor-user_area-api cmor-user_area-frontend; do
  cd "${i}"
  echo $PWD
  publish_gem
  cd ..
done