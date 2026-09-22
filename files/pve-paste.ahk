#Requires AutoHotkey v2.0

F8::
{
    text := A_Clipboard

    if (text = "")
        return

    ; Небольшая задержка перед началом ввода
    Sleep 300

    ; Посимвольно эмулируем клавиатуру
    Loop Parse, text
    {
        char := A_LoopField

        if (char = "`n")
        {
            Send "{Enter}"
        }
        else if (char = "`r")
        {
            continue
        }
        else if (char = "`t")
        {
            Send "{Tab}"
        }
        else
        {
            SendText char
        }

        Sleep 10
    }
}