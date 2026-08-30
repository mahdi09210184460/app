-- 1. Create Profiles Table (extends Auth.users)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT,
  phone_number TEXT UNIQUE,
  role TEXT DEFAULT 'user',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Create Categories Table
CREATE TABLE categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  icon_name TEXT, -- Store icon name as string
  color_code TEXT, -- Store color as hex string
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Create Services Table
CREATE TABLE services (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  category_id UUID REFERENCES categories(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  price_per_1000 NUMERIC NOT NULL,
  min_quantity INTEGER DEFAULT 100,
  max_quantity INTEGER DEFAULT 100000,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Create Orders Table
CREATE TABLE orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  service_title TEXT NOT NULL,
  link TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  total_price NUMERIC NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. Create Gateways Table
CREATE TABLE gateways (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- RLS SETTINGS (Row Level Security)

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update their own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read access for categories" ON categories FOR SELECT USING (true);

ALTER TABLE services ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read access for services" ON services FOR SELECT USING (true);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own orders" ON orders FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own orders" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);

ALTER TABLE gateways ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read access for gateways" ON gateways FOR SELECT USING (true);

-- Trigger to create profile on signup with 50,000 bonus
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, phone_number, balance)
  VALUES (new.id, new.raw_user_meta_data->>'full_name', new.phone, 50000);

  -- Record bonus transaction
  INSERT INTO public.transactions (user_id, amount, description, type)
  VALUES (new.id, 50000, 'هدیه خوش‌آمدگویی دیدینو 🎁', 'credit');

  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
