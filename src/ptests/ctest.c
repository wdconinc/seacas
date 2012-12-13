#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include "pcgnslib.h"
#include "mpi.h"

#define MIN_COUNT 40320 /* 8! */

int main(int argc, char *argv[])
{
    int comm_size, comm_rank;
    int total_count, scale_factor = 10;
    int F, B, Z, E, S;
    int Cx, Cy, Cz, Fx, Fy, Fz, Ax, Ay, Az;
    int i, j, n, nb, nz, n_per_proc, errs;
    double *x, *y, *z;
    cgsize_t sizes[3], *e, start, end;
    char name[33];
    double ts, tt, data_size;
    static char *piomode[2] = {"independent", "collective"};
    static char *outmode[2] = {"direct", "queued"};

    MPI_Init(&argc,&argv);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_size);
    MPI_Comm_rank(MPI_COMM_WORLD, &comm_rank);
    if (comm_size > 8) {
        if (comm_rank == 0)
            fprintf(stderr, "number of processes must be 8 or less\n");
        return 1;
    }
    if (argc > 1) {
        scale_factor = atoi(argv[1]);
        if (scale_factor < 1) {
            if (comm_rank == 0)
                fprintf(stderr, "invalid scale factor: %s\n", argv[1]);
            return 1;
        }
    }
    
    total_count = scale_factor * MIN_COUNT;
    n_per_proc = total_count / comm_size;
    x = (double *)malloc(n_per_proc * sizeof(double));
    y = (double *)malloc(n_per_proc * sizeof(double));
    z = (double *)malloc(n_per_proc * sizeof(double));
    e = (cgsize_t *)malloc(4 * n_per_proc * sizeof(cgsize_t));
    
    start = comm_rank * n_per_proc + 1;
    end   = start + n_per_proc - 1;
    for (j = 0, n = 0; n < n_per_proc; n++) {
        x[n] = start + n;
        y[n] = comm_rank + 1;
        z[n] = n + 1;
        for (i = 0; i < 4; i++, j++)
            e[j] = start + n;
    }
    sizes[0] = total_count;
    sizes[1] = total_count;
    sizes[2] = 0;

    data_size = (9.0 * total_count * sizeof(double) +
                 4.0 * total_count * sizeof(cgsize_t)) /
                 (1024.0 * 1024.0);
    if (comm_rank == 0) {
        printf("number processes       = %d\n", comm_size);
        printf("array size per process = %d\n", n_per_proc);
        printf("total array size       = %d\n", total_count);
        printf("total Mb for all data  = %lf\n", data_size);
    }

    if (cgp_open("ctest.cgns", CG_MODE_WRITE, &F))
        cgp_error_exit();

    for (nb = 0; nb < 2; nb++) {
        sprintf(name, "Base %d", nb + 1);
        if (cg_base_write(F,name,3,3,&B) ||
            cgp_pio_mode((CGNS_ENUMT(PIOmode_t))nb))
            cgp_error_exit();
        for (nz = 0; nz < 2; nz++) {
            sprintf(name, "Zone %d", nz + 1);
            if (cg_zone_write(F,B,name,sizes,CGNS_ENUMV(Unstructured),&Z) ||
                cgp_coord_write(F,B,Z,CGNS_ENUMV(RealDouble),"CoordinateX",&Cx) ||
                cgp_coord_write(F,B,Z,CGNS_ENUMV(RealDouble),"CoordinateY",&Cy) ||
                cgp_coord_write(F,B,Z,CGNS_ENUMV(RealDouble),"CoordinateZ",&Cz) ||
                cgp_section_write(F,B,Z,"Tets",CGNS_ENUMV(TETRA_4),1,total_count,0,&E) ||
                cg_sol_write(F,B,Z,"Solution",CGNS_ENUMV(Vertex),&S) ||
                cgp_field_write(F,B,Z,S,CGNS_ENUMV(RealDouble),"MomentumX",&Fx) ||
                cgp_field_write(F,B,Z,S,CGNS_ENUMV(RealDouble),"MomentumY",&Fy) ||
                cgp_field_write(F,B,Z,S,CGNS_ENUMV(RealDouble),"MomentumZ",&Fz))
                cgp_error_exit();
            if (cg_goto(F,B,name,0,NULL) ||
                cg_user_data_write("User Data") ||
                cg_gorel(F, "User Data", 0, NULL) ||
                cgp_array_write("ArrayX",CGNS_ENUMV(RealDouble),1,sizes,&Ax) ||
                cgp_array_write("ArrayY",CGNS_ENUMV(RealDouble),1,sizes,&Ay) ||
                cgp_array_write("ArrayZ",CGNS_ENUMV(RealDouble),1,sizes,&Az))
                cgp_error_exit();

            if (cgp_queue_set(nz)) cgp_error_exit();
            MPI_Barrier(MPI_COMM_WORLD);
            ts = MPI_Wtime();

            if (cgp_coord_write_data(F,B,Z,Cx,&start,&end,x) ||
                cgp_coord_write_data(F,B,Z,Cy,&start,&end,y) ||
                cgp_coord_write_data(F,B,Z,Cz,&start,&end,z) ||
                cgp_elements_write_data(F,B,Z,E,start,end,e) ||
                cgp_field_write_data(F,B,Z,S,Fx,&start,&end,x) ||
                cgp_field_write_data(F,B,Z,S,Fy,&start,&end,y) ||
                cgp_field_write_data(F,B,Z,S,Fz,&start,&end,z) ||
                cg_goto(F,B,"Zone_t",Z,"UserDefinedData_t",1,NULL) ||
                cgp_array_write_data(Ax,&start,&end,x) ||
                cgp_array_write_data(Ay,&start,&end,y) ||
                cgp_array_write_data(Az,&start,&end,z))
                cgp_error_exit();

            if (nz && cgp_queue_flush()) cgp_error_exit();
            MPI_Barrier(MPI_COMM_WORLD);
            tt = MPI_Wtime() - ts;
            if (comm_rank == 0) {
                printf("write: %lf secs, %lf Mb/sec (%s,%s)\n",
                    tt, data_size / tt, piomode[nb], outmode[nz]);
            }
        }
    }

    cgp_queue_set(0);
    if (cgp_close(F) ||
        cgp_open("ctest.cgns", CG_MODE_READ, &F)) cgp_error_exit();

    Z = S = E = 1;
    for (nb = 0; nb < 2; nb++) {
        B = nb + 1;
        if (cgp_pio_mode((CGNS_ENUMT(PIOmode_t))nb))
            cgp_error_exit();

        MPI_Barrier(MPI_COMM_WORLD);
        ts = MPI_Wtime();

        if (cgp_coord_read_data(F,B,Z,1,&start,&end,x) ||
            cgp_coord_read_data(F,B,Z,2,&start,&end,y) ||
            cgp_coord_read_data(F,B,Z,3,&start,&end,z) ||
            cgp_elements_read_data(F,B,Z,E,start,end,e)) cgp_error_exit();

        MPI_Barrier(MPI_COMM_WORLD);
        tt = MPI_Wtime() - ts;

        errs = 0;
        for (j = 0, n = 0; n < n_per_proc; n++) {
            if (x[n] != (double)(start + n)) errs++;
            if (y[n] != (double)(comm_rank + 1)) errs++;
            if (z[n] != (double)(n + 1)) errs++;
            for (i = 0; i < 4; i++, j++) {
                if (e[j] != (start + n)) errs++;
            }
        }

        MPI_Barrier(MPI_COMM_WORLD);
        ts = MPI_Wtime();

        if (cgp_field_read_data(F,B,Z,S,1,&start,&end,x) ||
            cgp_field_read_data(F,B,Z,S,2,&start,&end,y) ||
            cgp_field_read_data(F,B,Z,S,3,&start,&end,z)) cgp_error_exit();

        MPI_Barrier(MPI_COMM_WORLD);
        tt += (MPI_Wtime() - ts);

        for (n = 0; n < n_per_proc; n++) {
            if (x[n] != (double)(start + n)) errs++;
            if (y[n] != (double)(comm_rank + 1)) errs++;
            if (z[n] != (double)(n + 1)) errs++;
        }

        MPI_Barrier(MPI_COMM_WORLD);
        ts = MPI_Wtime();

        if (cg_goto(F,B,"Zone_t",Z,"UserDefinedData_t",1,NULL) ||
            cgp_array_read_data(1,&start,&end,x) ||
            cgp_array_read_data(2,&start,&end,y) ||
            cgp_array_read_data(3,&start,&end,z)) cgp_error_exit();

        MPI_Barrier(MPI_COMM_WORLD);
        tt += (MPI_Wtime() - ts);

        for (n = 0; n < n_per_proc; n++) {
            if (x[n] != (double)(start + n)) errs++;
            if (y[n] != (double)(comm_rank + 1)) errs++;
            if (z[n] != (double)(n + 1)) errs++;
        }

        if (comm_rank == 0) {
            printf("read : %lf secs, %lf Mb/sec (%s) errors=%d\n",
                tt, data_size / tt, piomode[nb], errs);
        }
    }

    cgp_close(F);    
    MPI_Finalize();
    return 0;
}

