# 🚀 Termux Dependency Installer v2.0

একটি অটোমেটেড Bash স্ক্রিপ্ট যা Termux-এ প্রয়োজনীয় সব ডেভেলপমেন্ট টুলস ও প্যাকেজ এক ক্লিকেই ইনস্টল করে দেয়।

---

## ✨ ফিচার সমূহ (Features)

- ✅ ইন্টারনেট কানেকশন চেক
- ✅ Termux প্যাকেজ লিস্ট আপডেট ও আপগ্রেড (`apt update && apt upgrade`)
- ✅ Python3 ও Pip ইনস্টল (আগে থেকে থাকলে স্কিপ করে)
- ✅ PHP ইনস্টল
- ✅ দরকারি Python প্যাকেজ ইনস্টল (নিচে তালিকা দেওয়া আছে)
- ✅ Optional Extra Tools ইনস্টল (ইউজারকে জিজ্ঞেস করে)
- ✅ Termux Storage Setup (`termux-setup-storage`)
- ✅ `.bashrc`-এ কাস্টম Aliases ও সুন্দর PS1 Prompt যোগ করে
- ✅ কালারফুল টার্মিনাল আউটপুট ও প্রোগ্রেস স্ট্যাটাস
- ✅ ইনস্টলেশন লগ ফাইল (`logs/install.log`, `logs/error.log`)
- ✅ শেষে Installed Versions ও Summary রিপোর্ট দেখায়

---

## 📦 যা যা ইনস্টল হবে

### সিস্টেম প্যাকেজ (apt)
| প্যাকেজ | কাজ |
|---|---|
| `python3` | Python ইন্টারপ্রেটার |
| `python3-pip` | Python প্যাকেজ ম্যানেজার |
| `php` | PHP রানটাইম |

### Python প্যাকেজ (pip)
- `requests`
- `packaging`
- `psutil`
- `colorama`
- `tqdm`
- `pyfiglet`
- `termcolor`

### Extra Tools (Optional — চাইলে ইনস্টল করবে)
- `curl`
- `wget`
- `git`
- `nano`
- `tree`
- `htop`
- `openssl`
- `jq`
- `figlet`
- `toilet`

---

## ⚙️ ইনস্টলেশন ও ব্যবহার (How to Run)

Termux ওপেন করে নিচের কমান্ডগুলো ধাপে ধাপে চালান:

```bash
# ১.
git clone https://github.com/device2331-beep/Auto-intall-package-.git

# ২.
cd Auto-intall-package-

# ৩. 
chmod +x mhm.sh

# ৪. স্ক্রিপ্ট রান করুন
./mhm.sh
```

রান করার সময় স্ক্রিপ্ট আপনাকে জিজ্ঞেস করবে Extra Tools ইনস্টল করবেন কিনা — `y` চাপলে ইনস্টল হবে, Enter চাপলে বা ১০ সেকেন্ড কিছু না করলে স্কিপ হয়ে যাবে।

---

## 💡 ইনস্টলের পর কিছু কাজের Alias

স্ক্রিপ্ট `.bashrc`-এ কিছু কাস্টম alias যোগ করে দেয়:

| Alias | কমান্ড |
|---|---|
| `ll` | `ls -la` |
| `py` | `python3` |
| `update` | `apt update && apt upgrade -y` |
| `venv` | `python3 -m venv venv` |
| `activate` | `source venv/bin/activate` |
| `pipup` | সব pip প্যাকেজ আপডেট করে |

```

---

## ⚠️ সতর্কতা

- Ctrl+C চাপলে ইনস্টলেশন যেকোনো সময় বন্ধ করা যাবে।
- ইন্টারনেট কানেকশন না থাকলে স্ক্রিপ্ট শুরুতেই বন্ধ হয়ে যাবে।
- `set -e` থাকায় কোনো কমান্ড ফেইল করলে স্ক্রিপ্ট থেমে যেতে পারে — এরর লগ চেক করুন।

---

## 📄 লাইসেন্স

এই প্রজেক্টের লাইসেন্স সংক্রান্ত তথ্য repository-তে যোগ করা থাকলে সেটি অনুসরণ করুন। কিছু উল্লেখ না থাকলে ব্যবহারের আগে repo owner-এর সাথে যোগাযোগ করার পরামর্শ দেওয়া হচ্ছে।
