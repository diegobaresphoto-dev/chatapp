const { Client } = require('pg');

async function seed() {
    const client = new Client({
        connectionString: 'postgresql://chatuser:chatpass@localhost:5432/chatdb',
    });

    try {
        await client.connect();
        const code = 'FOTO2024';
        await client.query(
            'INSERT INTO invitations (id, code, "maxUses", uses) VALUES (gen_random_uuid(), $1, 10, 0) ON CONFLICT (code) DO NOTHING',
            [code]
        );
        console.log(`✅ Invitación creada: ${code}`);
    } catch (err) {
        console.error('❌ Error:', err.message);
    } finally {
        await client.end();
    }
}

seed();
