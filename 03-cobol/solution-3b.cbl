       IDENTIFICATION DIVISION.
       PROGRAM-ID. solution-3b.

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
       01 ws-eof PIC A.
       01 ws-line-count PIC 9999 VALUE ZEROES.
       01 ws-tree-count PIC 9999 VALUE ZEROES.
       01 ws-index PIC 9999 VALUE 1.
       01 ws-slope-right PIC 9 VALUE ZEROES.
       01 ws-slope-down PIC 9 VALUE ZEROES.
       01 ws-output-number PIC 9999999999999 VALUE 1.
      * Variables for scratch calculations and trashing intermediate
      * results. (E.g. when we only want the remainder of a division.)
       01 ws-scratch PIC 9999 VALUE ZEROES.
       01 ws-discard PIC 9999 VALUE ZEROES.

       PROCEDURE DIVISION.
       para-main.
           MOVE 1 TO ws-slope-right
           MOVE 1 TO ws-slope-down
           PERFORM para-process-file

           MOVE 3 TO ws-slope-right
           MOVE 1 TO ws-slope-down
           PERFORM para-process-file

           MOVE 5 TO ws-slope-right
           MOVE 1 TO ws-slope-down
           PERFORM para-process-file

           MOVE 7 TO ws-slope-right
           MOVE 1 TO ws-slope-down
           PERFORM para-process-file

           MOVE 1 TO ws-slope-right
           MOVE 2 TO ws-slope-down
           PERFORM para-process-file

           DISPLAY ws-output-number

           STOP RUN
           .

       para-process-file.
           MOVE 'N' TO ws-eof
           MOVE ZEROES TO ws-tree-count
           MOVE ZEROES TO ws-line-count
           MOVE 1 TO ws-index

           OPEN INPUT fd-input

           PERFORM UNTIL ws-eof='Y'
               READ fd-input INTO ws-line
                   AT END MOVE 'Y' TO ws-eof
                   NOT AT END PERFORM para-line
               END-READ
           END-PERFORM

           DISPLAY ws-tree-count
           MULTIPLY ws-output-number BY ws-tree-count
               GIVING ws-output-number

           CLOSE fd-input
           .

       para-line.
      * Check if we're on a line that is evenly divided by the downward
      * slope we're on. If not, then we skip this line.
           DIVIDE ws-line-count BY ws-slope-down GIVING ws-discard
             REMAINDER ws-scratch

           IF ws-scratch = 0
      * Calculate the index into the current line we're on based on the
      * downward and rightward slope.
               COMPUTE ws-scratch = (ws-line-count / ws-slope-down)
                                    * ws-slope-right
               DIVIDE ws-scratch BY 31 GIVING ws-discard
                 REMAINDER ws-index
               ADD 1 TO ws-index GIVING ws-index

               IF ws-line(ws-index:1) = '#'
                   ADD 1 TO ws-tree-count GIVING ws-tree-count
               END-IF
           END-IF

           ADD 1 TO ws-line-count GIVING ws-line-count
           .
