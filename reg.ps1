# First_Step_reg

# Get-Item 명령어로 조회
# 참고 소스
#(Get-Item -Path $key_1 | Select-Object -ExpandProperty Property | Out-File -FilePath 'C:\Users\dkejd\OneDrive\바탕 화면\study\project\PC_Check\HKLM_Run.txt')
#(Get-Item -Path $key_2 | Select-Object -ExpandProperty Property | Out-File -FilePath 'C:\Users\dkejd\OneDrive\바탕 화면\study\project\PC_Check\HKLM_RunOnce.txt')
#(Get-Item -Path $key_3 | Select-Object -ExpandProperty Property | Out-File -FilePath 'C:\Users\dkejd\OneDrive\바탕 화면\study\project\PC_Check\HKCU_Run.txt')
#(Get-Item -Path $key_4 | Select-Object -ExpandProperty Property | Out-File -FilePath 'C:\Users\dkejd\OneDrive\바탕 화면\study\project\PC_Check\HKCU_RunOnce.txt')

# Registry Query Function
Function Reg {
    $key_1 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
    $key_2 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'
    $key_3 = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
    $key_4 = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'

    $p1 = Get-Item -Path $key_1 | Select-Object -ExpandProperty Property
    $p2 = Get-Item -Path $key_2 | Select-Object -ExpandProperty Property
    $p3 = Get-Item -Path $key_3 | Select-Object -ExpandProperty Property
    $p4 = Get-Item -Path $key_4 | Select-Object -ExpandProperty Property

    # 누적 저장(>>), 덮어 씌위기(Out-File)
    #$p1 + $p2 + $p3 + $p4 | Out-File -FilePath 'C:\Users\dkejd\OneDrive\바탕 화면\study\project\PC_Check\result.txt'
    $result = $p1 + $p2 + $p3 + $p4

    $result
}

# 프로세스 목록 후 비교 조회
Function Check {
    #if파일 X
    # 생성 후 프로세스 목록 쓰기
    # else
    #  if 파일 내용 비교 (현재 결과 둘다 같으면)
    #   "새 프로세스가 없습니다." 출력
    #  else
    #   "새로운 프로세스 검출" 출력 후 파일 내용 출력

    $file = 'C:\Users\dkejd\OneDrive\바탕 화면\study\project\PC_Check\result.txt'
    
    (Reg)
    (Get-Content $file)

    if ( -not (Test-Path $file)) {
        Reg | Out-File -FilePath 'C:\Users\dkejd\OneDrive\바탕 화면\study\project\PC_Check\result.txt'
    }
    else {
        if ((Reg) -eq (Get-Content $file)) {
            Write-Host "새 프로세스가 없습니다."
        }
        else {
            Write-Host "새로운 프로세스 검출."
            Reg | Out-File -FilePath 'C:\Users\dkejd\OneDrive\바탕 화면\study\project\PC_Check\result.txt'
        }
    }
}

# Check 함수 실행
Check




# 1. 현재 날짜, 시간 등을 기입하여 누적 저장하여 비교
# 2. 악성 프로세스 목록을 넣어 비교