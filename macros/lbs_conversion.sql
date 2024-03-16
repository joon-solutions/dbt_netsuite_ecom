{%- macro lbs_conversion (data_base,field_to_convert,unit_field='size_units') -%}
        case 
            when {{ data_base }}{{ field_to_convert }} is not null and {{ data_base }}{{ field_to_convert }} > 0 then
                case 
                    when {{ data_base }}{{ unit_field }} ='lb' 
                        then {{ data_base }}{{ field_to_convert }}
                    when {{ data_base }}{{ unit_field }} ='oz' 
                        then {{ data_base }}{{ field_to_convert }}*0.0625
                    when {{ data_base }}{{ unit_field }} ='g' 
                        then {{ data_base }}{{ field_to_convert }}*0.0022
                    when {{ data_base }}{{ unit_field }} ='kg' 
                        then {{ data_base }}{{ field_to_convert }}*2.2046                                              
            end
        end as {{ field_to_convert }}_lb
{%- endmacro -%}