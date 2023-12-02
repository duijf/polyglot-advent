       IDENTIFICATION DIVISION.
       PROGRAM-ID. solution-3a.

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
       01 ws-line-count PIC 9999 VALUE ZEROES.
       01 ws-tree-count PIC 9999 VALUE ZEROES.
       01 ws-index PIC 9999 VALUE 1.
      * Variable for scratch calculations. Not used for control flow.
       01 ws-scratch PIC 9999 VALUE ZEROES.

       PROCEDURE DIVISION.
       para-main.
           OPEN INPUT fd-input

           PERFORM UNTIL ws-eof='Y'
               READ fd-input INTO ws-line
                   AT END MOVE 'Y' TO ws-eof
                   NOT AT END PERFORM para-line
               END-READ
           END-PERFORM

           DISPLAY ws-tree-count

           CLOSE fd-input

           STOP RUN
           .

       para-line.
           MULTIPLY ws-line-count BY 3 GIVING ws-scratch
           DIVIDE ws-scratch BY 31 GIVING ws-scratch REMAINDER ws-index
           ADD 1 TO ws-index GIVING ws-index

           IF ws-line(ws-index:1) = '#'
              ADD 1 TO ws-tree-count GIVING ws-tree-count
           END-IF

           ADD 1 TO ws-line-count GIVING ws-line-count
           .
