@extends('layouts.app')

@section('title', 'Chat with ' . $partner->name)

@section('content')
<!-- Chat Header -->
<div class="bg-white px-3 py-3 border-b border-slate-200 flex items-center justify-between sticky top-7 z-30 shadow-xs">
    <div class="flex items-center gap-2.5">
        <a href="{{ route('chats') }}" class="p-1.5 text-slate-700 hover:text-slate-900">
            <i class="fa-solid {{ ($isRtl ?? true) ? 'fa-arrow-right' : 'fa-arrow-left' }} text-base"></i>
        </a>
        <div class="w-9 h-9 rounded-full bg-blue-100 text-blue-700 font-bold flex items-center justify-center text-sm">
            {{ mb_substr($partner->name, 0, 1) }}
        </div>
        <div>
            <h2 class="text-xs font-bold text-slate-900">{{ $partner->name }}</h2>
            <div class="text-[10px] text-emerald-600 font-medium flex items-center gap-1">
                <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
                <span>{{ ($isRtl ?? true) ? 'متصل الآن' : 'Online' }}</span>
            </div>
        </div>
    </div>

    <div class="flex items-center gap-2">
        <a href="tel:{{ $partner->phone }}" class="p-2 text-blue-600 bg-blue-50 rounded-xl hover:bg-blue-100 text-xs">
            <i class="fa-solid fa-phone"></i>
        </a>
    </div>
</div>

<!-- Messages Thread Container -->
<div class="p-4 space-y-3 min-h-[60vh] bg-slate-50 flex flex-col justify-end">
    @forelse($messages as $msg)
        <div class="flex {{ $msg->sender_id === $currentUserId ? 'justify-end' : 'justify-start' }}">
            <div class="max-w-[75%] p-3 rounded-2xl text-xs {{ $msg->sender_id === $currentUserId ? 'bg-blue-600 text-white rounded-br-xs' : 'bg-white text-slate-800 border border-slate-200 rounded-bl-xs shadow-xs' }}">
                <p class="leading-relaxed">{{ $msg->message }}</p>
                <div class="text-[9px] mt-1 text-end {{ $msg->sender_id === $currentUserId ? 'text-blue-200' : 'text-slate-400' }}">
                    {{ $msg->created_at->format('H:i') }}
                </div>
            </div>
        </div>
    @empty
        <div class="text-center py-10 text-xs text-slate-400">
            {{ ($isRtl ?? true) ? 'ابدأ المحادثة الآن' : 'Start conversation now' }}
        </div>
    @endforelse
</div>

<!-- Send Box -->
<div class="sticky bottom-16 bg-white border-t border-slate-200 p-3">
    <form action="{{ route('chats.send', $partner->id) }}" method="POST" class="flex items-center gap-2">
        @csrf
        <input type="text" name="message" required placeholder="{{ ($isRtl ?? true) ? 'اكتب رسالتك...' : 'Type a message...' }}"
            class="flex-1 bg-slate-100 text-slate-800 py-2.5 px-3.5 rounded-xl text-xs focus:outline-none focus:ring-2 focus:ring-blue-400 border-0">
        <button type="submit" class="bg-blue-600 text-white w-10 h-10 rounded-xl flex items-center justify-center shadow hover:bg-blue-700 transition">
            <i class="fa-solid fa-paper-plane text-xs"></i>
        </button>
    </form>
</div>
@endsection
