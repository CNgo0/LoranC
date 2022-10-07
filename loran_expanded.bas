10      REM LORAN-C ROUTINE. REV 07-15-83. 1530 HOURS
20      N9=15
        REM N9=NO. OF MASTER STATIONS
30      C0=1/298.26
        A0=-1
        PI=4.*ATN(1)
        TP=PI+PI
        RD=PI/180
        G$(1)=""
        GOTO 120
32      FOR C=1 TO 9
            C$=INKEY$
        NEXT C
33      PRINT
        PRINT "Press any key to continue."
34      C$=INKEY$
35      IF C$="" GOTO 34
39      RETURN
40      X=INT(M0*X+.5)/M0
        RETURN
50      P=129.04398/T-.40758+.645765438E-3*T
        RETURN
60      P=2.7412979/T-.32774624-3*T
        RETURN
70      C$=INKEY$
        IF C$="" GOTO 70
80      C=ASC(C$)
        C$=CHR$(C+32*(C>90))
90      FOR C=1 TO LEN(C0$)
            IF C$=MID$(C0$,C,1) THEN RETURN
100     NEXT C
        GOTO 70
110     CLS
120     PRINT "1-LORAN FIX      6-TWO PT HEAD & DIST"
130     PRINT "2-ALT. SOLUTION  7-CALIBRATE"
140     PRINT "3-DEST LAT/LON   8-NEW STA. IDs"
150     PRINT "4-HEAD & DIST    9-ASF Correction"
160     PRINT "5-PREDICT ITDs   A-STOP"
170     PRINT
        PRINT "OPTION?"
        C0$="123456789A"
        GOSUB 70
180     CLS
        ON C GOSUB 910,950,1010,1040,1090,990,1200,190,1320,530
        GOTO 120
185     IF G1$<>"" THEN RETURN
190     F0=1
        N=1
        CLS
        INPUT "1st GRI";I$
200     GOSUB 380
        GOSUB 390
        IF F0=2 GOTO 190
210     F0=1
        N=2
        INPUT "2nd GRI";I$
        GOSUB 380
220     IF A$=I9$ THEN GOSUB 470
        IF F0=1 GOTO 250
240     GOSUB 390
        IF F0=2 GOTO 210
250     F1=1
        F2=1
        IF G1$=G2$ GOTO 300
260     IF P(1,1)=P(1,2) AND L(1,1)+L(1,2) GOTO 310
270     F2=-1
        IF P(1,1)=P(2,2) AND L(1,1)+L(2,2) GOTO 310
280     F1=-1
        IF P(2,1)=P(2,2) AND L(2,1)+L(2,2) GOTO 310
290     F2=2
        IF P(2,1)=P(1,2) AND L(2,1)+L(1,2) GOTO 310
300     PRINT "ERROR NO TRIPLET."
        GOSUB 32
        GOTO 190
310     PRINT
        PRINT "Working"
        FOR I=1 TO 2
            P1=P(1,I)
            L1=L(1,I)
            P2=P(2,I)
            L2=L(2,I)
320         GOSUB 330
        NEXT I
        G(1)=0
        G(2)=0
        RETURN
330     GOSUB 650
        B(I)=S0
        Z(1,I)=Z1
        Z(2,I)=Z2
340     T=21282.3593*S0
350     IF T>=537 THEN GOSUB 50
360     IF T<537 THEN GOSUB 60
370     T(I)=T+P
        RETURN
380     L=LEN(I$)
        A$=LEFT$(I$,L-1)
        B$=RIGHT$(I$,1)
        B=ASC(B$)
        B$=CHR$(B+32*(B>90))
        RETURN
390     N8=1
        RESTORE
400     READ I9$,N0,P0,L0
410     FOR I=1 TO N0
            READ W$(I),D9(I),P1(I),L1(I)
        NEXT I
420     IF I9$<>A$ GOTO 450
430     GOSUB 470
        IF F0=2 GOTO 460
440     RETURN
450     N8=N8+1
        IF N8<=N9 GOTO 400
460     PRINT I$;" IS NOT CATALOGED"
        F0=2
        GOSUB 32
        RETURN
470     FOR I=1 TO N0
            IF W$(I)=B$ GOTO 490
480     NEXT I
        F0=2
        RETURN
490     IF N=1 THEN G1$=I$
        G$(1)=I$
500     IF N=2 THEN G2$=I$
        G$(2)=I$
510     D(N)=D9(I)
        X=P0
        GOSUB 1370
        P(1,N)=X
        X=L0
        GOSUB 1360
        L(1,N)=V*RD
520     X=P1(I)
        GOSUB 1370
        P(2,N)=X
        X=L1(I)
        GOSUB 1360
        L(2,N)=V*RD
        RETURN
530     END
540     REM DIRECT SOLUTION
550     Z8=SIN(Z1)
        Z9=COS(Z1)
        P8=SIN(P1)
        P9=COS(P1)
        M=-Z8*P9
        C1=C0*M
        C2=C0*(1-M*M)/4
560     D=(1-C2)*(1-C2-C1*M)
        P=C2*(1+C1*M/2)/D
        N=P9*Z9
570     YY=N
        XX=P8
        GOSUB 1260
        S1=AN
        D0=S0/D
        U=2*(S1-D0)
        W=1-2*P*COS(U)
        V=COS(U+D0)
580     X=C2*C2*SIN(D0)*COS(D0*(2*V*V-1))
        Y=2*P*V*W*SIN(D0)
590     S2=D0+X-Y
        S8=SIN(S2)
        S9=COS(S2)
        K=SQR(M*M+(N*S9-P8*S8)^2)
600     P2=ATN((P8*S9+N*S8)/K)
610     YY=-S8*Z8
        XX=P9*S9-P8*S8*Z9
        GOSUB 1260
        S3=AN
620     H=C1*(1-C2)*S2-C1*C2*S8*COS(S1+S1-S2)
        L2=L1+S3-H
630     YY=-M
        XX=-(N*S9-P8*S8)
        GOSUB 1260
        Z2=AN
        RETURN
640     REM REVERSE SOLN
650     L3=L2-L1
        P3=(P2-P1)/2
        P4=(P1+P2)/2
660     P6=SIN(P3)
        P7=COS(P3)
        P8=SIN(P4)
        P9=COS(P4)
670     H=P7*P7-P8*P8
        L=P6*P6+H*SIN(L3/2)^2
        XX=SQR(L)
        GOSUB 1340
        D0=2*AN
680     U=2*P8*P8*P7*P7/(1-L)
        V=2*P6*P6*P9*P9/L
        X=U+V
        Y=U-V
        T=D0/SIN(D0)
        D=4*T*T
690     E=2*COS(D0)
        A=D*E
        C=T-(A-E)/2
        N1=X*(A+C*X)
        B=D+D
        N2=Y*(B+E*Y)
        N3=D*X*Y
700     D2=C0*C0*(N1-N2+N3)/64
        D1=C0*(T*X-Y)/4
        S0=(T-D1+D2)*SIN(D0)
710     M=32*T-(20*T-A)*X-(B+4)*Y
720     F=Y+Y-E*(4-X)
        G=C0*(T/2+C0*M/64)
        Q=-F*G*TAN(L3)/4
730     L4=(L3+Q)/2
        L8=SIN(L4)
        L9=COS(L4)
740     YY=P6*L9
        XX=P9*L8
        GOSUB 1260
        T1=AN
        YY=-P7*L9
        XX=P8*L8
        GOSUB 1260
        T2=AN
750     M0=TP
        X=T1+T2
        GOSUB 1250
        Z1=X
        X=T1-T2
        GOSUB 1250
        Z2=X
        RETURN
760     REM FIXING ROUTINE
770     A1=F1*SIN(A(1))
        B1=COS(A(1))-COS(B(1))
        C1=SIN(B(1))
780     A2=F2*SIN(A(2))
        B2=COS(A(2))-COS(B(2))
        C2=SIN(B(2))
790     E1=Z(1,1)
        IF F1=-1 THEN E1=Z(2,1)
800     E2=Z(1,2)
        IF F2=-1 THEN E2=Z(2,2)
810     C=B1*C2*COS(E2)-B2*C1*COS(E1)
        S=B1*C2*SIN(E2)-B2*C1*SIN(E1)
820     K=B2*A1-B1*A2
        R=SQR(C*C+S*S)
        YY=S
        XX=C
        GOSUB 1260
        G=AN
830     XX=K/R
        GOSUB 1350
        Z=G+A0*AN
        YY=B2
        XX=C2*COS(Z-E2)+A2
        GOSUB 1260
        S0=AN
840     IF F2=1 THEN P1=P(1,2)
        L1=L(1,2)
850     IF F2=-1 THEN P1=P(2,2)
        L1=L(2,2)
860     Z1=Z
        GOSUB 550
        P0=P2
        L0=L2
        P=ATN(TAN(P0)/(1-C0))
870     P=P/RD
        X=L0/RD
        M0=360
        GOSUB 1250
        L=X
        IF L>180 THEN L=L-360
880     X=P
        GOSUB 1280
        P$=C$
        X=L
        GOSUB 1280
890     PRINT
        PRINT "LAT  = ";P$
        PRINT "LONG = ";C$
        RETURN
900     REM OPT 1
910     GOSUB 185
        CLS
        FOR I=1 TO 2
920         PRINT "ITD FOR ";G$(I);
            INPUT A
            A=A+G(I)-D(I)-T(I)
            IF ABS(A)<T(I) GOTO 940
930         PRINT "ITD NOT VALID FOR ";G$(I)
            GOSUB 32
940         A(I)=A/21295.8736
        NEXT I
        GOSUB 770
        GOSUB 32
        RETURN
945     REM OPT 2
950     IF A0=1 THEN A0=-1
        GOTO 970
960     A0=1
970     GOSUB 770
        GOSUB 32
        RETURN
980     REM OPT 6
990     CLS
        INPUT "ORIGIN LAT    dd.mmss ";P
        INPUT "ORIGIN LONG   ddd.mmss";L
1000    X=P
        GOSUB 1370
        P0=X
        X=L
        GOSUB 1360
        L0=V*RD
        GOSUB 1010
        GOSUB 1040
        RETURN
1010    CLS
        INPUT "DEST LAT      dd.mmss";P
        INPUT "DEST LONG     ddd.mmss";L
1020    X=P
        GOSUB 1370
        P5=X
        X=L
        GOSUB 1360
        L5=V*RD
        RETURN
1030    REM OPT 4
1040    P1=P0
        L1=L0
        P2=P5
        L2=L5
        GOSUB 650
1050    M0=360
        X=Z1/RD
        GOSUB 1250
        GOSUB 1280
1060    CLS
        PRINT "HEADING = ";C$
        M0=100
        X=3443.917*S0
        GOSUB 40
        PRINT "DISTANCE = ";X;" n. mi."
1070    GOSUB 32
        RETURN
1080    REM OPT 5
1090    GOSUB 185
        GOSUB 1170
        PRINT
        FOR K=1 TO 2
            I9=T(K)+D(K)
1100        P2=P(2,K)
            L2=L(2,K)
            GOSUB 650
            I=3
            GOSUB 340
            I9=I9+T(3)
1110        P2=P(1,K)
            L2=L(1,K)
            GOSUB 650
            I=3
            GOSUB 340
            I9=I9-T(3)
1120        M0=100
            X=I9
            GOSUB 40
1130        PRINT "ITD FOR ";G$(K);" = ";X
        NEXT K
1140    PRINT
        PRINT "New lat/long or Return to menu?"
        C0$="NR"
        GOSUB 70
1150    IF C=1 GOTO 1090
1160    RETURN
1170    CLS
        INPUT "LAT dd.mmss";P1
        INPUT "LONG ddd.mmss";L1
1180    X=P1
        GOSUB 1370
        P1=X
        X=L1
        GOSUB 1360
        L1=V*RD
        RETURN
1190    REM OPT 7
1200    GOSUB 185
        GOSUB 1170
        FOR K=1 TO 2
            I$=G1$
            IF K=2 THEN I$=G2$
1210        CLS
            PRINT "ITD FOR ";I$;
            INPUT I9
            I9=I9-D(K)
1220        P2=P(2,K)
            L2=L(2,K)
            GOSUB 650
            I=3
            GOSUB 340
            I9=I9-T(3)
1230        P2=P(1,K)
            L2=L(1,K)
            GOSUB 650
            I=3
            GOSUB 340
            T(K)=I9+T(3)+G(K)
1240    NEXT K
        RETURN
1250    X=X-M0*INT(X/M0)
        REM MOD FCTN
1260    AN=ATN(YY/(XX-1E-9*(XX=0)))-PI*(XX<0)
        RETURN
        REM QATN
1270    X=ATN((1-C0)*TAN(X))
        RETURN
1280    C$=" "
        IF X<0 THEN C$="-"
        X=-X
1290    X=X+1/7200
        X0=INT(X)
        C$=C$+STR$(X0)+" "
1300    X=60*(X-X0)
        X0=INT(X)
        X$=STR$(100+X0)
        C$=C$+RIGHT$(X$,2)+" "
1310    X=60*(X-X0)
        X0=INT(X)
        X$=STR$(100+X0)
        C$=C$+RIGHT$(X$,2)+" "
        RETURN
1320    GOSUB 185
        CLS
        PRINT "ASF FOR ";G$(1);INPUT G(1)
1330    PRINT "ASF FOR ";G$(2);
        INPUT G(2)
        RETURN
1340    ZZ=SQR(1-XX*XX)
        AN=ATN(XX/(ZZ-1E-9*(ZZ=0)))
        RETURN
        REM ASIN
1350    AN=ATN(SQR(1-XX*XX)/(XX-1E-9*(XX=0)))-PI*(XX<0)
        RETURN
        REM ACOS
1360    S=SGN(X)
        X=ABS(X)
        H=INT(X)
        M0=1
        GOSUB 1250
        V=X*100
        X=V
        GOSUB 1250
1365    V=S*((100*X/60+INT(V))/60+H)
        RETURN
1370    GOSUB 1360
        X=V*RD
        GOSUB 1270
        RETURN
5000    DATA    "4990",2,16.444395,169.30312,"X",11000,20.144916,155.53097
5010    DATA    "Y",29000,28.234177,178.17302
5020    DATA    "5930",2,46.4827199,67.5537713,"X",11000,41.151193,69.583909
5030    DATA    "Y",25000,46.46463218,53.102816
5040    DATA    "5970",3,36.1105797,-129.2027279,"W",11000,42.4437104,-143.4309245
5050    DATA    "X",31000,35.0223871,-126.322674,"Z",42000,263624975,-128.0856445
5060    DATA    "5990",3,51.575878,122.220224,"X",11000,55.2620851,131.1519648
5070    DATA    "Y",27000,47.034799,119.443953,"Z",41000,50.3629731,127.2129043
5080    DATA    "7930",3,59.591727,45.102747,"W",11000,64.542658,23.552175
5090    DATA    "X",21000,62.175964,7.042658,"Z",43000,46.463218,53.102816
5100    DATA    "*7930",3,24.1707888,-153.5853232,"X",11000,42.4437104,-143.4309245
5110    DATA    "Y",30000,26.3624975,-128.856445,"Z",49000,9.3245789,-138.095497
5120    DATA    "7960",2,63.1942814,142.48319,"X",11000,57.262021,152.2211225
5130    DATA    "Y",26000,55.2620851,131.1519648
5140    DATA    "7970",4,62.175964,7.0426538,"W",26000,54.4829872,-8.1736312
5150    DATA    "X",11000,68.380615,-14.2747,"Y",46000,64.542658,23.552175
5160    DATA    "Z",60000,70.545261,8.435869
5170    DATA    "7980",4,30.593874,85.1009305,"W",11000,30.4333018,90.49436
5180    DATA    "X",23000,26.3155006,97.5000093,"Y",43000,27.0158393,80.0653429
5190    DATA    "Z",59000,34.0346081,77.5446654
5200    DATA    "7990",3,38.5220587,-16.4306159,"X",11000,35.3120787,-12.3130245
5210    DATA    "Y",29000,40.582095,-27.520152,"Z",47000,42.0336515,-3.1215512
5220    DATA    "8970",3,39.510754,87.291214,"W",11000,30.593874,85.1009305
5230    DATA    "X",28000,42.4250603,76.4933862,"Y",44000,48.3649844,94.331846
5240    DATA    "9940",3,39.3306621,118.495637,"W",11000,47.034799,119.443953
5250    DATA    "X",27000,38.465699,122.2944529,"Y",40000,35.191818,114.4817435
5270    DATA    "9960",4,42.4250603,76.4933862,"W",11000,46.4827199,67.5537713
5280    DATA    "X",25000,41.151193,69.583909,"Y",39000,34.0346081,77.5446654
5290    DATA    "Z",54000,39.510754,87.291214
5300    DATA    "9970",4,24.4803597,-141.1930303,"W",11000,24.1707888,-153.5853232
5310    DATA    "X",30000,42.4437104,-143.4309245,"Y",55000,26.3624975,-128.0856445
5320    DATA    "Z",75000,9.3245789,-138.095497
5330    DATA    "9990",3,57.091265,17.1506789,"X",11000,52.494404,-173.1048974
5340    DATA    "Y",29000,65.1440306,166.531255,"Z",43000,57.262021,152.2211225