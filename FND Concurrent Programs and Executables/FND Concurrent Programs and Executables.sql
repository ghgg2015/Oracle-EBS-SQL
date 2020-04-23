/*************************************************************************/
/*                                                                       */
/*                       (c) 2010-2020 Enginatics GmbH                   */
/*                              www.enginatics.com                       */
/*                                                                       */
/*************************************************************************/
-- Report Name: FND Concurrent Programs and Executables
-- Description: Concurrent programs, executables and program parameters
-- Excel Examle Output: https://www.enginatics.com/example/fnd-concurrent-programs-and-executables
-- Library Link: https://www.enginatics.com/reports/fnd-concurrent-programs-and-executables
-- Run Report: https://demo.enginatics.com/


select
fcpv.user_concurrent_program_name program,
fcpv.description,
fav.application_name,
fav.application_short_name,
fcpv.concurrent_program_name short_name,
fev.executable_name executable_short_name,
flv1.meaning method,
fev.execution_file_name,
fcpv.execution_options options,
flv2.meaning output_format,
xxen_util.meaning(fcpv.multi_org_category,'CONC_PROGRAM_CATEGORY',0) operating_unit_mode,
&column_parameters
case when fev.description is null and fev.user_executable_name<>fev.executable_name then fev.user_executable_name else fev.description end executable_description,
xxen_util.user_name(fcpv.created_by) created_by,
xxen_util.client_time(fcpv.creation_date) creation_date,
xxen_util.user_name(fcpv.last_updated_by) last_updated_by,
xxen_util.client_time(fcpv.last_update_date) last_update_date
from
fnd_application_vl fav,
fnd_concurrent_programs_vl fcpv,
fnd_executables_vl fev,
fnd_lookup_values flv1,
fnd_lookup_values flv2,
fnd_lookup_values flv3,
(select fdfcuv.* from fnd_descr_flex_col_usage_vl fdfcuv where '&enable_parameters'='Y') fdfcuv,
fnd_flex_value_sets ffvs
where
1=1 and
fav.application_id=fcpv.application_id and
fcpv.executable_application_id=fev.application_id and
fcpv.executable_id=fev.executable_id and
fev.execution_method_code=flv1.lookup_code(+) and
fcpv.output_file_type=flv2.lookup_code(+) and
fdfcuv.default_type=flv3.lookup_code(+) and
flv1.lookup_type(+)='CP_EXECUTION_METHOD_CODE' and
flv2.lookup_type(+)='CP_OUTPUT_FILE_TYPE' and
flv3.lookup_type(+)='FLEX_DEFAULT_TYPE' and
flv1.language(+)=userenv('lang') and
flv2.language(+)=userenv('lang') and
flv3.language(+)=userenv('lang') and
flv1.view_application_id(+)=0 and
flv2.view_application_id(+)=0 and
flv3.view_application_id(+)=0 and
flv1.security_group_id(+)=0 and
flv2.security_group_id(+)=0 and
flv3.security_group_id(+)=0 and
fcpv.application_id=fdfcuv.application_id(+) and
'$SRS$.'||fcpv.concurrent_program_name=fdfcuv.descriptive_flexfield_name(+) and
fdfcuv.descriptive_flex_context_code(+)='Global Data Elements' and
fdfcuv.flex_value_set_id=ffvs.flex_value_set_id(+)
order by
fav.application_name,
fcpv.user_concurrent_program_name,
fdfcuv.column_seq_num