DECLARE SUB PlayerCPU ()
DECLARE SUB Begin ()
DECLARE SUB Score ()
DECLARE SUB PlayerBar ()
DECLARE FUNCTION Ball ()
DECLARE SUB Table ()
SCREEN 7
DIM SHARED X, Y, XM, YM, YB, YC, SCR, TU, LVL

RANDOMIZE TIMER

Begin

Start:
CLS
'Values Setup
X = INT(RND * 100 + 30): Y = X
XM = (INT(RND * 80 + 40)) / 1000: YM = (INT(RND * 80 + 40)) / 1000
YB = 15
SCR = 0
TU = 100

PRINT "Made By Marcos Lopez": Score

'Game Loop
DO

    Table
    IF Ball THEN
        CLS
        Score
        LOCATE 11, 18: PRINT "You Lost!"
        LOCATE 13, 9: PRINT "Press ENTER to Play again!"
        PLAY "E8 A2"
        IF INPUT$(1) = CHR$(13) THEN GOTO Start ELSE END
    END IF
    PlayerBar
    PlayerCPU

LOOP
END

FUNCTION Ball

    'Clear
    CIRCLE (X, Y), 2, 0

    'Motion
    X = X + XM
    Y = Y + YM

    CIRCLE (X, Y), 2, 15

    'Bounding Colitions
    IF X <= 14 OR X >= 282 THEN XM = XM * -1: SOUND 3000, 1: SOUND 5000, 1
    IF Y <= 14 OR Y >= 178 THEN YM = YM * -1: SOUND 3500, 1

    'Bar Colition
    IF X <= 27 THEN
        IF Y >= YB AND Y <= YB + 40 THEN
            CIRCLE (X, Y), 2, 0
            XM = XM * -1
            X = 27
            Score
            SOUND 4000, 1: SOUND 5500, 1
        END IF
    END IF
    
    'Lose
    IF X < 14 THEN
        Ball = -1
    END IF

END FUNCTION

SUB Begin
    COLOR 11
    LOCATE 11, 18: PRINT "Ball Game"
    COLOR 3
    LOCATE 12, 15: PRINT "By Marcos Lopez"
    COLOR 7
    LOCATE 16, 9: PRINT "Press SPACE to continue..."
    DO
        IF INKEY$ = " " THEN EXIT DO
    LOOP
    CLS
    PRINT "INTRUCTIONS": PRINT
    PRINT TAB(3); "Use Num 8 and Num 2 to stop the ball"
    PRINT TAB(3); "from hitting your side of the wall."
    PRINT : PRINT TAB(3); "If you want to quit while playing,"
    PRINT TAB(3); "just press SPACE key."
    LOCATE 16, 10: PRINT "Press Space to Start!"
    DO
        IF INKEY$ = " " THEN EXIT DO
    LOOP
    COLOR 7
END SUB

SUB PlayerBar

    'Keys
    SELECT CASE INKEY$
        CASE IS = "8"
            IF NOT YB < 25 THEN
            LINE (20, YB)-(25, YB + 40), 0, BF
            YB = YB - 15
            END IF
        CASE IS = "2"
            IF NOT YB > 120 THEN
            LINE (20, YB)-(25, YB + 40), 0, BF
            YB = YB + 15
            END IF
        CASE IS = " "
            CLS
            PRINT "Hope you liked my game "; CHR$(1)
            END
    END SELECT

    LINE (20, YB)-(25, YB + 40), 15, BF

END SUB

SUB PlayerCPU

    TU = TU - 1
    IF TU <= 0 THEN
        IF Y >= 30 AND Y <= 155 THEN
            IF XM > 0 THEN
                LINE (285, YC)-(290, YC + 40), 0, BF
                YC = Y - 20
                LINE (285, YC)-(290, YC + 40), 15, BF
            END IF
        END IF
        TU = 100
    END IF

END SUB

SUB Score

    LOCATE 1, 25
    COLOR 11
    PRINT "Score:"
    LOCATE 1, 32
    COLOR 3
    PRINT USING "########"; SCR
    SCR = SCR + 100
    COLOR 7

    LVL = LVL + 1
    IF LVL >= 5 THEN
        LVL = 0
        XM = XM * 1.2
        YM = YM * 1.05
    END IF


END SUB

SUB Table

    LINE (11, 11)-(301, 181), 7, B
    LINE (10, 10)-(300, 180), 15, B

END SUB
