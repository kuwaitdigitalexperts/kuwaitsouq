@extends('layouts.app')

@section('title', ($isRtl ?? true) ? 'سياسة الخصوصية والشروط' : 'Privacy Policy & Terms')

@section('content')
<div class="bg-white px-4 pt-4 pb-3 border-b border-slate-100 flex items-center justify-between sticky top-7 z-30 shadow-xs">
    <div class="flex items-center gap-3">
        <a href="{{ route('home') }}" class="text-slate-600 hover:text-slate-900">
            <i class="fa-solid fa-arrow-right rtl:fa-arrow-right ltr:fa-arrow-left text-lg"></i>
        </a>
        <h1 class="text-xl font-black text-slate-900">
            {{ ($isRtl ?? true) ? 'سياسة الخصوصية' : 'Privacy Policy' }}
        </h1>
    </div>
    <span class="text-xs text-slate-400 font-semibold">KuwaitSouq</span>
</div>

<div class="max-w-3xl mx-auto px-4 py-8 space-y-8 text-slate-700 leading-relaxed">
    <!-- Intro Card -->
    <div class="bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 rounded-2xl p-6 shadow-xs">
        <div class="flex items-start gap-4">
            <div class="w-12 h-12 rounded-xl bg-blue-600 text-white flex items-center justify-center text-xl flex-shrink-0">
                <i class="fa-solid fa-shield-halved"></i>
            </div>
            <div>
                <h2 class="text-lg font-black text-slate-900">
                    {{ ($isRtl ?? true) ? 'سياسة الخصوصية لتطبيق وموقع كويت سوق' : 'KuwaitSouq Privacy Policy' }}
                </h2>
                <p class="text-xs text-slate-500 mt-1">
                    {{ ($isRtl ?? true) ? 'آخر تحديث: نوفمبر 2026' : 'Last Updated: November 2026' }}
                </p>
                <p class="text-sm text-slate-600 mt-2">
                    {{ ($isRtl ?? true) 
                        ? 'نحن في كويت سوق (KuwaitSouq) نلتزم بحماية خصوصية مستخدمينا وبياناتهم الشخصية. توضح هذه السياسة كيفية جمع البيانات واستخدامها وحمايتها عند استخدام تطبيق الهاتف أو الموقع الإلكتروني.' 
                        : 'At KuwaitSouq, we are committed to safeguarding the privacy and security of our users. This policy outlines how we collect, use, and protect your information when you use our mobile app or website.' }}
                </p>
            </div>
        </div>
    </div>

    <!-- Section 1 -->
    <div class="bg-white rounded-2xl border border-slate-200/80 p-6 space-y-3 shadow-xs">
        <h3 class="text-base font-bold text-slate-900 flex items-center gap-2">
            <i class="fa-solid fa-database text-blue-600"></i>
            <span>{{ ($isRtl ?? true) ? '1. البيانات التي نجمعها' : '1. Information We Collect' }}</span>
        </h3>
        <ul class="list-disc list-inside space-y-2 text-sm text-slate-600">
            <li><strong>{{ ($isRtl ?? true) ? 'معلومات الحساب:' : 'Account Details:' }}</strong> {{ ($isRtl ?? true) ? 'الاسم، رقم الهاتف، والبريد الإلكتروني عند التسجيل.' : 'Name, phone number, and email address upon registration.' }}</li>
            <li><strong>{{ ($isRtl ?? true) ? 'بيانات الإعلانات:' : 'Listing Content:' }}</strong> {{ ($isRtl ?? true) ? 'عنوان الإعلان، الوصف، الصور، مقاطع الفيديو، السعر، المنطقة/المحافظة في الكويت، ورقم التواصل/الواتساب الذي تختاره.' : 'Title, description, photos, videos, price, area/governorate in Kuwait, and the contact phone or WhatsApp you provide.' }}</li>
            <li><strong>{{ ($isRtl ?? true) ? 'المراسلات:' : 'Communications:' }}</strong> {{ ($isRtl ?? true) ? 'الرسائل الفورية المتبادلة بين المشترين والبائعين داخل التطبيق لتسهيل إتمام الصفقات بأمان.' : 'In-app chat messages exchanged between buyers and sellers to facilitate safe marketplace transactions.' }}</li>
            <li><strong>{{ ($isRtl ?? true) ? 'البيانات التقنية:' : 'Technical Data:' }}</strong> {{ ($isRtl ?? true) ? 'نوع الجهاز، نظام التشغيل، عنوان IP، ومعرّفات الأعطال لضمان استقرار التطبيق.' : 'Device model, operating system, IP address, and crash reports for application reliability.' }}</li>
        </ul>
    </div>

    <!-- Section 2 -->
    <div class="bg-white rounded-2xl border border-slate-200/80 p-6 space-y-3 shadow-xs">
        <h3 class="text-base font-bold text-slate-900 flex items-center gap-2">
            <i class="fa-solid fa-camera text-blue-600"></i>
            <span>{{ ($isRtl ?? true) ? '2. الأذونات المطلوبة في التطبيق' : '2. Device Permissions Required' }}</span>
        </h3>
        <p class="text-sm text-slate-600">
            {{ ($isRtl ?? true) ? 'يطلب التطبيق فقط الأذونات الضرورية لتقديم الخدمة الأساسية:' : 'The KuwaitSouq app requests only permissions necessary for its core features:' }}
        </p>
        <ul class="list-disc list-inside space-y-2 text-sm text-slate-600">
            <li><strong>{{ ($isRtl ?? true) ? 'الكاميرا (Camera):' : 'Camera:' }}</strong> {{ ($isRtl ?? true) ? 'لالتقاط صور ومقاطع فيديو مباشرة للسلع والمنتجات المراد عرضها للبيع.' : 'To capture live photos and videos of items you want to list for sale.' }}</li>
            <li><strong>{{ ($isRtl ?? true) ? 'الميكروفون (Microphone):' : 'Microphone:' }}</strong> {{ ($isRtl ?? true) ? 'لتسجيل الصوت أثناء تصوير فيديو للإعلان.' : 'To record audio when recording a video for your ad.' }}</li>
            <li><strong>{{ ($isRtl ?? true) ? 'معرض الصور (Photo Library):' : 'Photo Library / Storage:' }}</strong> {{ ($isRtl ?? true) ? 'لاختيار الصور ومقاطع الفيديو المحفوظة على جهازك لرفعها مع الإعلان.' : 'To select photos and videos from your device gallery to attach to your listings.' }}</li>
        </ul>
    </div>

    <!-- Section 3 -->
    <div class="bg-white rounded-2xl border border-slate-200/80 p-6 space-y-3 shadow-xs">
        <h3 class="text-base font-bold text-slate-900 flex items-center gap-2">
            <i class="fa-solid fa-gears text-blue-600"></i>
            <span>{{ ($isRtl ?? true) ? '3. كيف نستخدم بياناتك' : '3. How We Use Your Information' }}</span>
        </h3>
        <ul class="list-disc list-inside space-y-2 text-sm text-slate-600">
            <li>{{ ($isRtl ?? true) ? 'نشر إعلاناتك وإتاحتها للمشترين والمهتمين في الكويت.' : 'Publishing and showcasing your ads to buyers in Kuwait.' }}</li>
            <li>{{ ($isRtl ?? true) ? 'تسهيل التواصل المباشر بينك وبين المشترين عبر الاتصال، الواتساب، أو الدردشة.' : 'Enabling direct communication between buyers and sellers via phone, WhatsApp, or chat.' }}</li>
            <li>{{ ($isRtl ?? true) ? 'التحقق من أمان الحساب بواسطة رمز التحقق OTP (عبر خدمة Firebase من Google).' : 'Verifying user identity and account security via SMS OTP (powered by Google Firebase).' }}</li>
            <li>{{ ($isRtl ?? true) ? 'حظر الحسابات الاحتيالية والإعلانات المخالفة للقوانين المعمول بها في دولة الكويت.' : 'Preventing fraudulent listings, spam, and content violating laws in the State of Kuwait.' }}</li>
        </ul>
    </div>

    <!-- Section 4 -->
    <div class="bg-white rounded-2xl border border-slate-200/80 p-6 space-y-3 shadow-xs">
        <h3 class="text-base font-bold text-slate-900 flex items-center gap-2">
            <i class="fa-solid fa-user-lock text-blue-600"></i>
            <span>{{ ($isRtl ?? true) ? '4. مشاركة البيانات والجهات الخارجية' : '4. Data Sharing & Third Parties' }}</span>
        </h3>
        <p class="text-sm text-slate-600">
            {{ ($isRtl ?? true) 
                ? 'نحن لا نبيع بياناتك الشخصية لأي طرف ثالث على الإطلاق. نشارك البيانات فقط مع مقدمي الخدمات الموثوقين لتشغيل التطبيق:' 
                : 'We do not sell your personal data under any circumstances. We share data only with trusted service infrastructure providers:' }}
        </p>
        <ul class="list-disc list-inside space-y-2 text-sm text-slate-600">
            <li><strong>Google Firebase:</strong> {{ ($isRtl ?? true) ? 'للتحقق من أرقام الهواتف عبر رسائل OTP وتأمين تسجيل الدخول.' : 'For phone authentication via SMS OTP and secure sign-in.' }}</li>
            <li><strong>Apple & Google Sign-In:</strong> {{ ($isRtl ?? true) ? 'لتسجيل الدخول السريع والآمن.' : 'For secure one-tap social authentication.' }}</li>
        </ul>
    </div>

    <!-- Section 5 -->
    <div class="bg-white rounded-2xl border border-slate-200/80 p-6 space-y-3 shadow-xs">
        <h3 class="text-base font-bold text-slate-900 flex items-center gap-2">
            <i class="fa-solid fa-trash-can text-red-500"></i>
            <span>{{ ($isRtl ?? true) ? '5. حذف الحساب والبيانات (Account & Data Deletion)' : '5. Account & Data Deletion' }}</span>
        </h3>
        <p class="text-sm text-slate-600">
            {{ ($isRtl ?? true) 
                ? 'يحق لك في أي وقت حذف حسابك وجميع بياناتك وإعلاناتك نهائياً من خوادمنا:' 
                : 'You have the full right to permanently delete your account, ads, and personal data from our servers at any time:' }}
        </p>
        <ul class="list-disc list-inside space-y-2 text-sm text-slate-600">
            <li><strong>{{ ($isRtl ?? true) ? 'من داخل التطبيق:' : 'From within the App:' }}</strong> {{ ($isRtl ?? true) ? 'انتقل إلى تبويب "حسابي" > إعدادات الحساب > "حذف الحساب نهائياً".' : 'Navigate to "Account" tab > Settings > "Delete Account Permanently".' }}</li>
            <li><strong>{{ ($isRtl ?? true) ? 'عبر البريد الإلكتروني:' : 'Via Email:' }}</strong> {{ ($isRtl ?? true) ? 'أرسل طلباً إلى support@kuwaitsouq.online من بريدك المسجل وسيتم حذف الحساب خلال 48 ساعة.' : 'Email your deletion request to support@kuwaitsouq.online and your data will be permanently wiped within 48 hours.' }}</li>
        </ul>
    </div>

    <!-- Section 6: Contact -->
    <div class="bg-white rounded-2xl border border-slate-200/80 p-6 space-y-3 shadow-xs">
        <h3 class="text-base font-bold text-slate-900 flex items-center gap-2">
            <i class="fa-solid fa-envelope text-blue-600"></i>
            <span>{{ ($isRtl ?? true) ? '6. اتصل بنا' : '6. Contact Us' }}</span>
        </h3>
        <p class="text-sm text-slate-600">
            {{ ($isRtl ?? true) 
                ? 'إذا كانت لديك أي استفسارات أو ملاحظات بشأن سياسة الخصوصية، يرجى التواصل معنا:' 
                : 'If you have any questions or inquiries regarding our Privacy Policy, please contact us:' }}
        </p>
        <div class="flex flex-col sm:flex-row gap-3 pt-2">
            <a href="mailto:support@kuwaitsouq.online" class="inline-flex items-center gap-2 px-4 py-2.5 bg-blue-50 text-blue-700 font-bold text-xs rounded-xl hover:bg-blue-100 transition">
                <i class="fa-solid fa-envelope"></i>
                <span>support@kuwaitsouq.online</span>
            </a>
            <a href="https://kuwaitsouq.online" class="inline-flex items-center gap-2 px-4 py-2.5 bg-slate-100 text-slate-700 font-bold text-xs rounded-xl hover:bg-slate-200 transition">
                <i class="fa-solid fa-globe"></i>
                <span>kuwaitsouq.online</span>
            </a>
        </div>
    </div>
</div>
@endsection
