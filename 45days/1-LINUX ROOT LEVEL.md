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


```bash
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
labtop  sleep    slogin   

controlplane ~ ➜  ls -l /bin/sl
slabtop  sleep    slogin   

controlplane ~ ➜  ls -l /bin/sleep 
-rwxr-xr-x 1 root root 35336 Feb  8  2024 /bin/sleep

controlplane ~ ➜  sleep 300 &
[1] 56915

controlplane ~ ✦ ➜  echo $!
56915

controlplane ~ ✦ ➜  ps -o pid,ppid,stat,cmd -p 56915
    PID    PPID STAT CMD
  56915   43401 S    sleep 300

controlplane ~ ✦ ✖ pstree -p
systemd(1)─┬─containerd(904)─┬─{containerd}(915)
           │                 ├─{containerd}(916)
           │                 ├─{containerd}(919)
           │                 ├─{containerd}(920)
           │                 ├─{containerd}(921)
           │                 ├─{containerd}(922)
           │                 ├─{containerd}(923)
           │                 ├─{containerd}(924)
           │                 ├─{containerd}(925)
           │                 ├─{containerd}(926)
           │                 ├─{containerd}(928)
           │                 ├─{containerd}(930)
           │                 ├─{containerd}(932)
           │                 ├─{containerd}(934)
           │                 ├─{containerd}(2100)
           │                 ├─{containerd}(2624)
           │                 ├─{containerd}(2639)
           │                 ├─{containerd}(2640)
           │                 ├─{containerd}(8116)
           │                 ├─{containerd}(8515)
           │                 ├─{containerd}(9081)
           │                 ├─{containerd}(10278)
           │                 ├─{containerd}(12292)
           │                 └─{containerd}(19987)
           ├─containerd-shim(2138)─┬─kube-scheduler(2731)─┬─{kube-scheduler}(2968)
           │                       │                      ├─{kube-scheduler}(2969)
           │                       │                      ├─{kube-scheduler}(2970)
           │                       │                      ├─{kube-scheduler}(2971)
           │                       │                      ├─{kube-scheduler}(2980)
           │                       │                      ├─{kube-scheduler}(2981)
           │                       │                      ├─{kube-scheduler}(2985)
           │                       │                      ├─{kube-scheduler}(2986)
           │                       │                      ├─{kube-scheduler}(2987)
           │                       │                      ├─{kube-scheduler}(2995)
           │                       │                      ├─{kube-scheduler}(2996)
           │                       │                      ├─{kube-scheduler}(2997)
           │                       │                      ├─{kube-scheduler}(3005)
           │                       │                      ├─{kube-scheduler}(3019)
           │                       │                      ├─{kube-scheduler}(3034)
           │                       │                      ├─{kube-scheduler}(3035)
           │                       │                      ├─{kube-scheduler}(11549)
           │                       │                      ├─{kube-scheduler}(11550)
           │                       │                      ├─{kube-scheduler}(11551)
           │                       │                      └─{kube-scheduler}(11552)
           │                       ├─pause(2305)
           │                       ├─{containerd-shim}(2148)
           │                       ├─{containerd-shim}(2149)
           │                       ├─{containerd-shim}(2150)
           │                       ├─{containerd-shim}(2151)
           │                       ├─{containerd-shim}(2157)
           │                       ├─{containerd-shim}(2159)
           │                       ├─{containerd-shim}(2161)
           │                       ├─{containerd-shim}(2162)
           │                       ├─{containerd-shim}(2165)
           │                       ├─{containerd-shim}(2167)
           │                       └─{containerd-shim}(20062)
           ├─containerd-shim(2153)─┬─kube-controller(2728)─┬─{kube-controller}(2998)
           │                       │                       ├─{kube-controller}(2999)
           │                       │                       ├─{kube-controller}(3000)
           │                       │                       ├─{kube-controller}(3001)
           │                       │                       ├─{kube-controller}(3002)
           │                       │                       ├─{kube-controller}(3003)
           │                       │                       ├─{kube-controller}(3006)
           │                       │                       ├─{kube-controller}(3007)
           │                       │                       ├─{kube-controller}(3008)
           │                       │                       ├─{kube-controller}(3009)
           │                       │                       ├─{kube-controller}(3010)
           │                       │                       ├─{kube-controller}(3011)
           │                       │                       ├─{kube-controller}(3013)
           │                       │                       ├─{kube-controller}(3012)
           │                       │                       ├─{kube-controller}(3014)
           │                       │                       └─{kube-controller}(3563)
           │                       ├─pause(2288)
           │                       ├─{containerd-shim}(2168)
           │                       ├─{containerd-shim}(2169)
           │                       ├─{containerd-shim}(2170)
           │                       ├─{containerd-shim}(2171)
           │                       ├─{containerd-shim}(2177)
           │                       ├─{containerd-shim}(2178)
           │                       ├─{containerd-shim}(2180)
           │                       ├─{containerd-shim}(2184)
           │                       ├─{containerd-shim}(2190)
           │                       ├─{containerd-shim}(2191)
           │                       └─{containerd-shim}(2192)
           ├─containerd-shim(2166)─┬─kube-apiserver(2719)─┬─{kube-apiserver}(2964)
           │                       │                      ├─{kube-apiserver}(2965)
           │                       │                      ├─{kube-apiserver}(2966)
           │                       │                      ├─{kube-apiserver}(2967)
           │                       │                      ├─{kube-apiserver}(2973)
           │                       │                      ├─{kube-apiserver}(2974)
           │                       │                      ├─{kube-apiserver}(2975)
           │                       │                      ├─{kube-apiserver}(2976)
           │                       │                      ├─{kube-apiserver}(2982)
           │                       │                      ├─{kube-apiserver}(2983)
           │                       │                      ├─{kube-apiserver}(2984)
           │                       │                      ├─{kube-apiserver}(3004)
           │                       │                      ├─{kube-apiserver}(3015)
           │                       │                      ├─{kube-apiserver}(3016)
           │                       │                      ├─{kube-apiserver}(3017)
           │                       │                      ├─{kube-apiserver}(3018)
           │                       │                      ├─{kube-apiserver}(3022)
           │                       │                      ├─{kube-apiserver}(3023)
           │                       │                      ├─{kube-apiserver}(3028)
           │                       │                      ├─{kube-apiserver}(3030)
           │                       │                      └─{kube-apiserver}(34134)
           │                       ├─pause(2289)
           │                       ├─{containerd-shim}(2173)
           │                       ├─{containerd-shim}(2174)
           │                       ├─{containerd-shim}(2175)
           │                       ├─{containerd-shim}(2176)
           │                       ├─{containerd-shim}(2179)
           │                       ├─{containerd-shim}(2181)
           │                       ├─{containerd-shim}(2183)
           │                       ├─{containerd-shim}(2182)
           │                       ├─{containerd-shim}(2189)
           │                       ├─{containerd-shim}(2551)
           │                       └─{containerd-shim}(2552)
           ├─containerd-shim(2172)─┬─etcd(2726)─┬─{etcd}(2960)
           │                       │            ├─{etcd}(2961)
           │                       │            ├─{etcd}(2962)
           │                       │            ├─{etcd}(2963)
           │                       │            ├─{etcd}(2972)
           │                       │            ├─{etcd}(2977)
           │                       │            ├─{etcd}(2978)
           │                       │            ├─{etcd}(2979)
           │                       │            ├─{etcd}(2988)
           │                       │            ├─{etcd}(3020)
           │                       │            ├─{etcd}(3021)
           │                       │            ├─{etcd}(3024)
           │                       │            ├─{etcd}(3025)
           │                       │            ├─{etcd}(3026)
           │                       │            ├─{etcd}(3027)
           │                       │            ├─{etcd}(3029)
           │                       │            ├─{etcd}(3031)
           │                       │            ├─{etcd}(3032)
           │                       │            ├─{etcd}(3033)
           │                       │            ├─{etcd}(10781)
           │                       │            └─{etcd}(11580)
           │                       ├─pause(2317)
           │                       ├─{containerd-shim}(2185)
           │                       ├─{containerd-shim}(2186)
           │                       ├─{containerd-shim}(2187)
           │                       ├─{containerd-shim}(2188)
           │                       ├─{containerd-shim}(2193)
           │                       ├─{containerd-shim}(2195)
           │                       ├─{containerd-shim}(2197)
           │                       ├─{containerd-shim}(2199)
           │                       ├─{containerd-shim}(2200)
           │                       ├─{containerd-shim}(2203)
           │                       └─{containerd-shim}(23902)
           ├─containerd-shim(3591)─┬─kube-proxy(3717)─┬─{kube-proxy}(3808)
           │                       │                  ├─{kube-proxy}(3809)
           │                       │                  ├─{kube-proxy}(3810)
           │                       │                  ├─{kube-proxy}(3811)
           │                       │                  ├─{kube-proxy}(3812)
           │                       │                  ├─{kube-proxy}(3830)
           │                       │                  ├─{kube-proxy}(3833)
           │                       │                  ├─{kube-proxy}(3834)
           │                       │                  ├─{kube-proxy}(3835)
           │                       │                  ├─{kube-proxy}(3836)
           │                       │                  ├─{kube-proxy}(3837)
           │                       │                  └─{kube-proxy}(8472)
           │                       ├─pause(3619)
           │                       ├─{containerd-shim}(3592)
           │                       ├─{containerd-shim}(3593)
           │                       ├─{containerd-shim}(3594)
           │                       ├─{containerd-shim}(3595)
           │                       ├─{containerd-shim}(3596)
           │                       ├─{containerd-shim}(3597)
           │                       ├─{containerd-shim}(3598)
           │                       ├─{containerd-shim}(3599)
           │                       ├─{containerd-shim}(3600)
           │                       ├─{containerd-shim}(3608)
           │                       └─{containerd-shim}(14251)
           ├─containerd-shim(3766)─┬─flanneld(4902)─┬─{flanneld}(4985)
           │                       │                ├─{flanneld}(4986)
           │                       │                ├─{flanneld}(4987)
           │                       │                ├─{flanneld}(4988)
           │                       │                ├─{flanneld}(4989)
           │                       │                ├─{flanneld}(4991)
           │                       │                ├─{flanneld}(4992)
           │                       │                ├─{flanneld}(4995)
           │                       │                ├─{flanneld}(4996)
           │                       │                ├─{flanneld}(5741)
           │                       │                ├─{flanneld}(5742)
           │                       │                ├─{flanneld}(5743)
           │                       │                ├─{flanneld}(5744)
           │                       │                ├─{flanneld}(9497)
           │                       │                ├─{flanneld}(9498)
           │                       │                ├─{flanneld}(10664)
           │                       │                ├─{flanneld}(11875)
           │                       │                ├─{flanneld}(16680)
           │                       │                ├─{flanneld}(17924)
           │                       │                └─{flanneld}(21717)
           │                       ├─pause(3797)
           │                       ├─runsvdir(4618)─┬─runsv(4715)───calico-node(4719)─┬─{calico-node}(4725)
           │                       │                │                                 ├─{calico-node}(4727)
           │                       │                │                                 ├─{calico-node}(4729)
           │                       │                │                                 ├─{calico-node}(4732)
           │                       │                │                                 ├─{calico-node}(4736)
           │                       │                │                                 ├─{calico-node}(4749)
           │                       │                │                                 ├─{calico-node}(4750)
           │                       │                │                                 ├─{calico-node}(4751)
           │                       │                │                                 ├─{calico-node}(4752)
           │                       │                │                                 ├─{calico-node}(4753)
           │                       │                │                                 ├─{calico-node}(4765)
           │                       │                │                                 ├─{calico-node}(4766)
           │                       │                │                                 ├─{calico-node}(4767)
           │                       │                │                                 ├─{calico-node}(4806)
           │                       │                │                                 ├─{calico-node}(4810)
           │                       │                │                                 ├─{calico-node}(4811)
           │                       │                │                                 ├─{calico-node}(4812)
           │                       │                │                                 ├─{calico-node}(7101)
           │                       │                │                                 ├─{calico-node}(7104)
           │                       │                │                                 ├─{calico-node}(9001)
           │                       │                │                                 └─{calico-node}(9002)
           │                       │                ├─runsv(4716)───calico-node(4721)─┬─{calico-node}(4724)
           │                       │                │                                 ├─{calico-node}(4726)
           │                       │                │                                 ├─{calico-node}(4728)
           │                       │                │                                 ├─{calico-node}(4730)
           │                       │                │                                 ├─{calico-node}(4735)
           │                       │                │                                 ├─{calico-node}(4754)
           │                       │                │                                 ├─{calico-node}(10724)
           │                       │                │                                 └─{calico-node}(10725)
           │                       │                ├─runsv(4717)───calico-node(4720)─┬─{calico-node}(4738)
           │                       │                │                                 ├─{calico-node}(4739)
           │                       │                │                                 ├─{calico-node}(4740)
           │                       │                │                                 ├─{calico-node}(4741)
           │                       │                │                                 ├─{calico-node}(4742)
           │                       │                │                                 ├─{calico-node}(4755)
           │                       │                │                                 ├─{calico-node}(4756)
           │                       │                │                                 ├─{calico-node}(4757)
           │                       │                │                                 ├─{calico-node}(4758)
           │                       │                │                                 └─{calico-node}(10726)
           │                       │                └─runsv(4718)───calico-node(4722)─┬─{calico-node}(4723)
           │                       │                                                  ├─{calico-node}(4731)
           │                       │                                                  ├─{calico-node}(4733)
           │                       │                                                  ├─{calico-node}(4734)
           │                       │                                                  ├─{calico-node}(4737)
           │                       │                                                  ├─{calico-node}(4743)
           │                       │                                                  ├─{calico-node}(4744)
           │                       │                                                  ├─{calico-node}(4745)
           │                       │                                                  ├─{calico-node}(4746)
           │                       │                                                  ├─{calico-node}(4747)
           │                       │                                                  └─{calico-node}(4748)
           │                       ├─{containerd-shim}(3767)
           │                       ├─{containerd-shim}(3768)
           │                       ├─{containerd-shim}(3769)
           │                       ├─{containerd-shim}(3770)
           │                       ├─{containerd-shim}(3771)
           │                       ├─{containerd-shim}(3772)
           │                       ├─{containerd-shim}(3773)
           │                       ├─{containerd-shim}(3774)
           │                       ├─{containerd-shim}(3775)
           │                       ├─{containerd-shim}(3782)
           │                       └─{containerd-shim}(3783)
           ├─containerd-shim(6491)─┬─kube-controller(8648)─┬─{kube-controller}(8782)
           │                       │                       ├─{kube-controller}(8783)
           │                       │                       ├─{kube-controller}(8784)
           │                       │                       ├─{kube-controller}(8785)
           │                       │                       ├─{kube-controller}(8786)
           │                       │                       ├─{kube-controller}(8787)
           │                       │                       ├─{kube-controller}(8788)
           │                       │                       ├─{kube-controller}(8789)
           │                       │                       ├─{kube-controller}(8790)
           │                       │                       ├─{kube-controller}(8835)
           │                       │                       ├─{kube-controller}(8836)
           │                       │                       ├─{kube-controller}(8837)
           │                       │                       ├─{kube-controller}(8838)
           │                       │                       └─{kube-controller}(10040)
           │                       ├─pause(6656)
           │                       ├─{containerd-shim}(6496)
           │                       ├─{containerd-shim}(6498)
           │                       ├─{containerd-shim}(6499)
           │                       ├─{containerd-shim}(6501)
           │                       ├─{containerd-shim}(6507)
           │                       ├─{containerd-shim}(6508)
           │                       ├─{containerd-shim}(6509)
           │                       ├─{containerd-shim}(6510)
           │                       ├─{containerd-shim}(6511)
           │                       ├─{containerd-shim}(7156)
           │                       └─{containerd-shim}(9044)
           ├─containerd-shim(6778)─┬─coredns(7785)─┬─{coredns}(8019)
           │                       │               ├─{coredns}(8020)
           │                       │               ├─{coredns}(8021)
           │                       │               ├─{coredns}(8022)
           │                       │               ├─{coredns}(8023)
           │                       │               ├─{coredns}(8025)
           │                       │               ├─{coredns}(8055)
           │                       │               ├─{coredns}(8062)
           │                       │               ├─{coredns}(8077)
           │                       │               ├─{coredns}(10242)
           │                       │               ├─{coredns}(10243)
           │                       │               ├─{coredns}(10244)
           │                       │               ├─{coredns}(10245)
           │                       │               └─{coredns}(10246)
           │                       ├─pause(6982)
           │                       ├─{containerd-shim}(6831)
           │                       ├─{containerd-shim}(6832)
           │                       ├─{containerd-shim}(6833)
           │                       ├─{containerd-shim}(6834)
           │                       ├─{containerd-shim}(6842)
           │                       ├─{containerd-shim}(6844)
           │                       ├─{containerd-shim}(6845)
           │                       ├─{containerd-shim}(6846)
           │                       ├─{containerd-shim}(6847)
           │                       └─{containerd-shim}(6848)
           ├─containerd-shim(6878)─┬─coredns(7775)─┬─{coredns}(7988)
           │                       │               ├─{coredns}(7989)
           │                       │               ├─{coredns}(7990)
           │                       │               ├─{coredns}(7991)
           │                       │               ├─{coredns}(7998)
           │                       │               ├─{coredns}(7999)
           │                       │               ├─{coredns}(8000)
           │                       │               ├─{coredns}(8007)
           │                       │               ├─{coredns}(8008)
           │                       │               ├─{coredns}(8009)
           │                       │               ├─{coredns}(8010)
           │                       │               ├─{coredns}(8011)
           │                       │               ├─{coredns}(8012)
           │                       │               ├─{coredns}(9894)
           │                       │               ├─{coredns}(9895)
           │                       │               ├─{coredns}(9896)
           │                       │               └─{coredns}(9897)
           │                       ├─pause(7076)
           │                       ├─{containerd-shim}(6882)
           │                       ├─{containerd-shim}(6883)
           │                       ├─{containerd-shim}(6884)
           │                       ├─{containerd-shim}(6885)
           │                       ├─{containerd-shim}(6922)
           │                       ├─{containerd-shim}(6923)
           │                       ├─{containerd-shim}(6924)
           │                       ├─{containerd-shim}(6925)
           │                       ├─{containerd-shim}(6926)
           │                       ├─{containerd-shim}(6973)
           │                       └─{containerd-shim}(42798)
           ├─dbus-daemon(830)
           ├─kubectl(3915)─┬─{kubectl}(3919)
           │               ├─{kubectl}(3921)
           │               ├─{kubectl}(3922)
           │               ├─{kubectl}(3923)
           │               ├─{kubectl}(3924)
           │               ├─{kubectl}(3938)
           │               ├─{kubectl}(3939)
           │               ├─{kubectl}(3954)
           │               └─{kubectl}(3955)
           ├─kubelet(3387)─┬─{kubelet}(3388)
           │               ├─{kubelet}(3389)
           │               ├─{kubelet}(3390)
           │               ├─{kubelet}(3391)
           │               ├─{kubelet}(3392)
           │               ├─{kubelet}(3399)
           │               ├─{kubelet}(3400)
           │               ├─{kubelet}(3401)
           │               ├─{kubelet}(3405)
           │               ├─{kubelet}(3406)
           │               ├─{kubelet}(3409)
           │               ├─{kubelet}(3410)
           │               ├─{kubelet}(3411)
           │               ├─{kubelet}(3419)
           │               ├─{kubelet}(3423)
           │               ├─{kubelet}(3472)
           │               ├─{kubelet}(3473)
           │               ├─{kubelet}(3474)
           │               ├─{kubelet}(3735)
           │               ├─{kubelet}(3736)
           │               ├─{kubelet}(4033)
           │               ├─{kubelet}(4564)
           │               └─{kubelet}(11700)
           ├─packagekitd(1263)─┬─{packagekitd}(1264)
           │                   └─{packagekitd}(1265)
           ├─polkitd(1273)─┬─{polkitd}(1274)
           │               └─{polkitd}(1276)
           ├─sshd(905)
           ├─start-ttyd.sh(903)───ttyd(908)─┬─script(43059)───sh(43061)───sudo(43062)───sudo(43063)───su(43064)───bash(43133)
           │                                ├─script(43393)───sh(43397)───sudo(43398)───sudo(43399)───su(43400)───bash(43401)─┬─pstree(60565)
           │                                │                                                                                 └─sleep(56915)
           │                                ├─{ttyd}(43060)
           │                                └─{ttyd}(43394)
           ├─systemd(43084)───(sd-pam)(43085)
           ├─systemd-journal(190)
           ├─systemd-logind(889)
           └─systemd-udevd(418)

controlplane ~ ✦ ➜  

```
