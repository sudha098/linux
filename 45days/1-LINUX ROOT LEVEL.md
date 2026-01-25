# 🩸 DAY 1 — LINUX FROM ROOT (DEEP VERSION)

---

## 🧠 PART 1 — OPERATING SYSTEM ACTUALLY HAI KYA?

Most log bolte hain:

> “Linux ek OS hai”

❌ Galat (incomplete).

### ✅ Sach:

**Operating System = Kernel + Userland tools**

* **Kernel** → boss (hardware control)
* **Userland** → tools (`ls`, `ps`, `bash`, `systemctl`)

Tum terminal me jo kuch bhi karte ho:
👉 **Kernel ke bina kuch nahi hota**

---

## 🧠 PART 2 — KERNEL DEEP UNDERSTANDING

### Kernel kya karta hai?

Kernel ke paas 4 superpowers hain:

### 1️⃣ CPU CONTROL (Scheduler)

CPU ek hi time pe:

* hazaar processes ko “chalata” hua lagta hai
  Par reality:
* CPU ek time pe **sirf ek instruction**

Kernel:

* process A ko 2 ms
* process B ko 2 ms
* switch, switch, switch ⚡

👉 Isse kehte hain **context switching**

---

### 2️⃣ MEMORY CONTROL (Yahan aadhe log mar jaate hain)

Tumhari app bole:

> “Mujhe 1GB RAM chahiye”

Kernel bole:

> “Le, par ye *virtual* hai”

#### Virtual Memory:

* App sochti hai uske paas full RAM hai
* Kernel actual RAM manage karta hai

Isliye:

* RSS ≠ VIRT
* Free RAM ≠ unused RAM

---

### 3️⃣ PROCESS CONTROL

Kernel decide karta hai:

* kaunsa process zinda
* kaunsa wait kare
* kaunsa mare (OOM killer 😈)

---

### 4️⃣ HARDWARE ACCESS

Disk, NIC, CPU, RAM
👉 **sirf kernel touch kar sakta hai**

App → syscall → kernel → driver → hardware

---

## 🧠 PART 3 — PROGRAM vs PROCESS (CRITICAL)

### Program:

* Disk pe pada hua file
* Dead
* Koi CPU nahi
* Koi RAM nahi

Example:

```bash
ls -l /bin/ls
```

---

### Process:

* Program + RAM + CPU context
* Alive
* PID hota hai

Example:

```bash
ls
```

👆 Ye command:

1. Bash ne fork kiya
2. Child process bana
3. Exec hua `/bin/ls`
4. Output diya
5. Exit

---

## 🧠 PART 4 — PROCESS LIFE CYCLE (ROOT)

```
New → Ready → Running → Waiting → Terminated
```

### Fork & Exec kya hai?

* `fork()` → copy of process
* `exec()` → program replace

Isliye:

* Bash zinda rehta hai
* Command alag process me chalti hai

---

## 🛠️ PRACTICAL 1 — PROCESS KO ZINDA DEKHO

```bash
sleep 300 &
echo $!
```

Ab:

```bash
ps -o pid,ppid,stat,cmd -p <PID>
```

### Fields samjho:

* PID → process id
* PPID → parent
* STAT:

  * R → running
  * S → sleeping
  * D → uninterruptible
  * Z → zombie ☠️

---

## 🧠 PART 5 — CPU DEEP TRUTH

### CPU 100% ka matlab?

❌ CPU busy = system slow (always)
✅ CPU busy = **scheduler under pressure**

### Load Average:

```bash
uptime
```

Load =

> running + waiting processes (not CPU usage!)

Example:

* 2 core system
* Load = 4
  👉 2 processes waiting = latency

---

## 🛠️ PRACTICAL 2 — CPU TORTURE

```bash
yes > /dev/null &
yes > /dev/null &
```

Observe:

```bash
top
uptime
```

Samjho:

* CPU % vs load difference
* Context switching increase

Cleanup:

```bash
killall yes
```

---

## 🧠 PART 6 — MEMORY (SABSE ZYADA CONFUSION)

### RAM ka rule:

> **Empty RAM = wasted RAM**

Kernel RAM use karta hai:

* cache
* buffers
* slab

Isliye:

```bash
free -m
```

Dekho:

* used
* free
* buff/cache
* available (IMPORTANT)

---

### Swap kyun hota hai?

* RAM limited hai
* Kernel rarely used pages disk pe daal deta hai
* RAM free karta hai for active processes

Swap ≠ bad
Swap abuse = bad

---

## 🛠️ PRACTICAL 3 — MEMORY PRESSURE

```bash
stress --vm 1 --vm-bytes 70% --vm-keep
```

Observe:

```bash
vmstat 1
```

Fields:

* si → swap in
* so → swap out

Cleanup:

```bash
pkill stress
```

---

## 🧠 PART 7 — ZOMBIE PROCESS (PROD KA BHOOT)

Zombie:

* Process mar chuka
* Entry process table me abhi hai
* Parent ne `wait()` nahi kiya

Danger:

* Process table full
* New processes fail

---

## 🧠 FINAL ROOT QUESTIONS (LIKHO)

Ye skip kiya toh training fail:

1. Program aur process me exact difference?
2. Kernel ke bina Docker kyun impossible hai?
3. Load average CPU % se zyada important kyun hai?
4. Swap hone ke baad bhi system responsive kyun rehta hai?
5. Zombie process ka real prod impact kya hai?

---

## 🎯 DAY 1 KA REAL OUTCOME

Agar tum ye samajh gaye:

* Kubernetes crash samajh aayega
* Pod OOMKill logic clear hoga
* “system slow hai” bolne ke bajaye **reason doge**

---

🔥 **Next (DAY 2):**
**Networking from ROOT**
👉 packet → NIC → kernel → socket → process

Reply me:

* Root questions ke answers (short)
* Ek line: *“abhi bhi sabse zyada confusion kahan hai”*

Main wahin ghus jaunga 😈🧠

-------------------------------------------------------------------------------------------------------------------------
controlplane ~ ➜  uname -a
Linux controlplane 5.15.0-1083-gcp #92~20.04.1-Ubuntu SMP Tue Apr 29 09:12:55 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux

controlplane ~ ➜  

controlplane ~ ➜  lscpu
Architecture:             x86_64
  CPU op-mode(s):         32-bit, 64-bit
  Address sizes:          46 bits physical, 48 bits virtual
  Byte Order:             Little Endian
CPU(s):                   16
  On-line CPU(s) list:    0-15
Vendor ID:                GenuineIntel
  Model name:             Intel(R) Xeon(R) CPU @ 2.80GHz
    CPU family:           6
    Model:                85
    Thread(s) per core:   2
    Core(s) per socket:   8
    Socket(s):            1
    Stepping:             7
    BogoMIPS:             5600.44
    Flags:                fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdp
                          e1gb rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid
                           sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single ssbd 
                          ibrs ibpb stibp ibrs_enhanced fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm avx512f avx512dq rdseed adx
                           smap clflushopt clwb avx512cd avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves arat avx512_vnni md_clear arch_capabil
                          ities
Virtualization features:  
  Hypervisor vendor:      KVM
  Virtualization type:    full
Caches (sum of all):      
  L1d:                    256 KiB (8 instances)
  L1i:                    256 KiB (8 instances)
  L2:                     8 MiB (8 instances)
  L3:                     33 MiB (1 instance)
NUMA:                     
  NUMA node(s):           1
  NUMA node0 CPU(s):      0-15
Vulnerabilities:          
  Gather data sampling:   Not affected
  Itlb multihit:          Not affected
  L1tf:                   Not affected
  Mds:                    Not affected
  Meltdown:               Not affected
  Mmio stale data:        Vulnerable: Clear CPU buffers attempted, no microcode; SMT Host state unknown
  Reg file data sampling: Not affected
  Retbleed:               Mitigation; Enhanced IBRS
  Spec rstack overflow:   Not affected
  Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl and seccomp
  Spectre v1:             Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:             Mitigation; Enhanced / Automatic IBRS; IBPB conditional; RSB filling; PBRSB-eIBRS SW sequence; BHI SW loop, KVM SW loo
                          p
  Srbds:                  Not affected
  Tsx async abort:        Vulnerable: Clear CPU buffers attempted, no microcode; SMT Host state unknown

controlplane ~ ➜  

controlplane ~ ➜  free -m
               total        used        free      shared  buff/cache   available
Mem:           64295       13782        1049         246       49462       49549
Swap:              0           0           0

controlplane ~ ➜  

controlplane ~ ➜  
