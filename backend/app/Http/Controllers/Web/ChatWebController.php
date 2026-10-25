<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Message;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ChatWebController extends Controller
{
    public function index()
    {
        if (!Auth::check()) {
            return redirect()->route('login')->with('info', 'يرجى تسجيل الدخول للوصول إلى المحادثات.');
        }

        $userId = Auth::id();

        // Find distinct chat contacts
        $messages = Message::where('sender_id', $userId)
            ->orWhere('receiver_id', $userId)
            ->with(['sender', 'receiver', 'ad'])
            ->latest()
            ->get();

        $contacts = [];
        foreach ($messages as $msg) {
            $otherUser = $msg->sender_id === $userId ? $msg->receiver : $msg->sender;
            if ($otherUser && !isset($contacts[$otherUser->id])) {
                $contacts[$otherUser->id] = [
                    'user' => $otherUser,
                    'last_message' => $msg,
                    'unread_count' => Message::where('sender_id', $otherUser->id)
                        ->where('receiver_id', $userId)
                        ->where('is_read', false)
                        ->count(),
                ];
            }
        }

        return view('web.chats.index', compact('contacts', 'userId'));
    }

    public function show(int $userId)
    {
        if (!Auth::check()) {
            return redirect()->route('login')->with('info', 'يرجى تسجيل الدخول للوصول إلى المحادثة.');
        }

        $currentUserId = Auth::id();
        $partner = User::findOrFail($userId);

        $messages = Message::where(function ($q) use ($currentUserId, $userId) {
            $q->where('sender_id', $currentUserId)->where('receiver_id', $userId);
        })->orWhere(function ($q) use ($currentUserId, $userId) {
            $q->where('sender_id', $userId)->where('receiver_id', $currentUserId);
        })->with('ad')->orderBy('created_at')->get();

        // Mark as read
        Message::where('sender_id', $userId)->where('receiver_id', $currentUserId)->update(['is_read' => true]);

        return view('web.chats.show', compact('partner', 'messages', 'currentUserId'));
    }

    public function send(Request $request, int $userId)
    {
        if (!Auth::check()) {
            return redirect()->route('login');
        }

        $request->validate(['message' => 'required|string']);

        $currentUserId = Auth::id();
        Message::create([
            'sender_id' => $currentUserId,
            'receiver_id' => $userId,
            'message' => $request->message,
            'is_read' => false,
        ]);

        return redirect()->route('chats.show', $userId);
    }
}
