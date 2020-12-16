       IDENTIFICATION DIVISION.
       PROGRAM-ID. solution-1a.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT fd-input
           ASSIGN TO 'input'
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD fd-input.
       01 fs-line PIC A(31).

       WORKING-STORAGE SECTION.
       01 ws-line PIC A(31).
       01 ws-eof PIC A VALUE 'N'.

       PROCEDURE DIVISION.
       para-main.
           OPEN INPUT fd-input

           PERFORM UNTIL ws-eof='Y'
               READ fd-input INTO ws-line
                   AT END MOVE 'Y' TO ws-eof
                   NOT AT END PERFORM para-line
               END-READ
           END-PERFORM

           CLOSE fd-input

           STOP RUN
           .

       para-line.
           DISPLAY ws-line
           .
