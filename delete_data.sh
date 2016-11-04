mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;delete from operation where company_id=$1;delete from auto_base_day_report where company_id=$1;delete from auto_base_report where company_id=$1;delete from auto_good_day_report where company_id=$1;delete from auto_good_report where company_id=$1;"
echo "删除成功........"

