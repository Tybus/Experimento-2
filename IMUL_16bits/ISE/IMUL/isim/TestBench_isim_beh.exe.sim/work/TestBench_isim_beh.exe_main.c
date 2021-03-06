/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000003102923598_0317860448_init();
    work_m_00000000001674002442_1260173457_init();
    work_m_00000000004185835305_1201854419_init();
    work_m_00000000002829962819_0988927962_init();
    work_m_00000000001452587283_3659960860_init();
    work_m_00000000001443874997_3015076048_init();
    work_m_00000000000255180804_0936592367_init();
    work_m_00000000001060713429_0924759715_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000001060713429_0924759715");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
