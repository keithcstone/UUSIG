#include <ertran.h> 
#include <stddef.h> 
#include <stdio.h>  
#include <stdlib.h> 
#include <string.h> 
#include <sysutil.h>
#include <fp$defs.h>
#include <fp$file$id.h> 
#include <fp$generic.h> 
#include <fp$rtn$file.h>
#include <fp$rtn$info.h>
#include <fp$acqfillst.h>   
    
    
int usencmp( fp_rtn_file_info_type *p_file_info, char *p_name) {
    
    int i;  
    fp_rtn_file_info_asg_type *p_run_asg_info;  
    
    p_run_asg_info = (fp_rtn_file_info_asg_type *)  
             ((int *) p_file_info + p_file_info->run_asg_info_offset);  
    for ( i = 0; i < p_run_asg_info->num_use_names; i++)
        if( strncmp( p_run_asg_info->use_name[i],p_name,strlen(p_name)) == 0 )  
            return 0;   
    return 1;   
    }   

    
int main() {
    
    fp_acq_file_list_type  acq_pkt; 
    fp_file_id_type        file_id; 
    fp_rtn_file_info_type *p_file_info; 
    int i,j,file_buffer[20000],files_freed; 
    int get_userid = 1,info_status,initreg[12],brkpt;   
    char file[60],cmd_line[96],userid[13],ipf_user_file[17];
    
    printf("freeall 0R4 %s %s\n",__TIME__,__DATE__);
    
    ucsinitreg(initreg);
    brkpt = (initreg[3] << 1) >> 35;

    ucsinfo(&get_userid,&info_status,userid);   
    sprintf(ipf_user_file,"IPF$%s",userid); 
    for (j = 0; j < 16; j++)
        if (ipf_user_file[j] == ' ')
            ipf_user_file[j] = '\0';

    memset(&acq_pkt,0,sizeof(fp_acq_file_list_type));   
    acq_pkt.gen.interface_level = fp_interface_level_1; 
    acq_pkt.gen.null_term_strings = TRUE;   
    acq_pkt.gen.work_area_size = fp_max_work_area_acq_file_list;
    acq_pkt.info_detail = fp_detail_long;   
    acq_pkt.rtn_run_asg_info = TRUE;
    acq_pkt.search_set  = fp_search_asgd_to_run;
    acq_pkt.lifetime    = fp_lifetime_cataloged;
    acq_pkt.rtn_info.rtn_area_size = (sizeof file_buffer) / 4;  
    
    _fp_acq_file_list(&acq_pkt,file_buffer,NULL);   
    
    if (acq_pkt.gen.error_class != fp_error_class_none) {   
        printf("End freeall: furpur error code: %u\n",  
                acq_pkt.gen.error_code % 01000000); 
        exit(EXIT_FAILURE); 
        }   
    
    puts("files freed:\n"); 
    files_freed = 0;
    for( p_file_info = (fp_rtn_file_info_type *) file_buffer, i = 0;
         i < acq_pkt.rtn_info.num_entries_in_rtn_area;  
         p_file_info = (fp_rtn_file_info_type *)
           ((int *) p_file_info + p_file_info->full_entry_size) , i++) {
    
        if (strncmp( p_file_info->filename,ipf_user_file,strlen(ipf_user_file)) == 0 || 
            strncmp( p_file_info->qualifier,"SYS$WS",strlen("SYS$WS")) == 0 ||  
           (brkpt && usencmp( p_file_info,"$BRK$" ) == 0 ) ||   
            usencmp( p_file_info,"FRED$VM" ) == 0 ) 
            ;   
        else {  
            for (j = 0; j < 12; j++) {  
                if( p_file_info->qualifier[j] == ' ')   
                    p_file_info->qualifier[j] = '\0';   
                if( p_file_info->filename[j] == ' ')
                    p_file_info->filename[j] = '\0';
                }   
    
            sprintf(file,"%.12s*%.12s(%d).",
                p_file_info->qualifier, 
                p_file_info->filename,  
                p_file_info->f_cycle);  

            sprintf(cmd_line,"@free,r %s . ",file); 
            system(cmd_line);   
            files_freed++;  
            printf("    %s\n",file);
            }   
      } 

    printf("End freeall: %u files freed\n",files_freed);
    return EXIT_SUCCESS;
    }   
